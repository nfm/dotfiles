# Copyright (c) 2015-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#
import re
import os
import subprocess

import logger

# If you are using a code grep query service and want to resolve
# certain global symbols to local directories,
# add them as REPOS below. We will essentially replace a global
# match against something like:
#   www/myFile.py
# to:
#   ~/www/myFile.py
REPOS = ['www']

MASTER_REGEX = re.compile(
    '(\/?([a-z.A-Z0-9\-_]+\/)+[+@a-zA-Z0-9\-_+.]+\.[a-zA-Z0-9]{1,10})[:-]{0,1}(\d+)?')
HOMEDIR_REGEX = re.compile(
    '(~\/([a-z.A-Z0-9\-_]+\/)+[@a-zA-Z0-9\-_+.]+\.[a-zA-Z0-9]{1,10})[:-]{0,1}(\d+)?')
OTHER_BGS_RESULT_REGEX = re.compile(
    '(\/?([a-z.A-Z0-9\-_]+\/)+[a-zA-Z0-9_.]{3,})[:-]{0,1}(\d+)')
JUST_FILE = re.compile(
    '([@+a-z.A-Z0-9\-_]+\.[a-zA-Z]{1,10})(\s|$|:)+')
FILE_NO_PERIODS = re.compile(''.join((
    '(',
    # Recognized files starting with a dot followed by at least 3 characters
    '((\/?([a-z.A-Z0-9\-_]+\/))?\.[a-zA-Z0-9\-_]{3,}[a-zA-Z0-9\-_\/]*)',
    # or
    '|',
    # Recognize files containing at least one slash
    '([a-z.A-Z0-9\-_\/]{1,}\/[a-zA-Z0-9\-_]{1,})',
    ')',
    # Regardless of the above case, here's how the file name should terminate
    '(\s|$|:)+'
)))
MASTER_REGEX_WITH_SPACES = re.compile(''.join((
    # begin the capture
    '(',
    # a leading / for absolute dirs if its there
    '\/?',
    # now we look at directories. The 'character class ' allowed before the '/'
    # is either a real character or a character and a space. This allows
    # multiple spaces in a directory as long as each space is followed by
    # a normal character, but it does not allow multiple continguous spaces
    # which would otherwise gobble up too much whitespace.
    #
    # Thus, these directories will match:
    #   /something foo/
    #   / a b c d e/
    #   /normal/
    #
    # but these will not:
    #   /two  spaces  here/
    #   /ending in a space /
    '(([a-z.A-Z0-9\-_]|\s[a-zA-Z0-9\-_])+\/)+',
    # we do similar for the filename part. the 'character class' is
    # char or char with space following, with some added tokens like @
    # for retina files.
    '([@a-zA-Z0-9\-_+.]|\s[@a-zA-Z0-9\-_+.])+',
    # extensions dont allow spaces
    '\.[a-zA-Z0-9]{1,10}'
    # end capture
    ')',
    # optionally capture the line number
    '[:-]{0,1}(\d+)?',
)))


REGEX_WATERFALL = [{
    # Homedirs need a separate regex.
    'regex': HOMEDIR_REGEX,
}, {
    # the master regex matches tbgs results with
    # line numbers, so we prefer that and test it first
    'regex': MASTER_REGEX,
    # one real quick check -- did we find a better match
    # earlier in the regex?
    'preferred_regex': OTHER_BGS_RESULT_REGEX,
}, {
    # if something clearly looks like an *bgs result but
    # just has a weird filename (like all caps with no extension)
    # then we can match that as well. Note that we require
    # the line number match since otherwise this would be too lax
    # of a regex.
    'regex': OTHER_BGS_RESULT_REGEX,
}, {
    # We would overmatch on wayyyyy too many things if we
    # allowed spaces everywhere, but with filesystem validation
    # and the final fallback we can include them.
    'regex': MASTER_REGEX_WITH_SPACES,
    'numIndex': 4,
    'onlyWithFileInspection': True,
}, {
    # ok maybe its just a normal file (with a dot)
    # so lets test for that if the above fails
    'regex': JUST_FILE,
    'noNum': True
}, {
    # ok finally it might be a file with no periods. we test
    # this last since its more restrictive, because we dont
    # want to match things like cx('foo/root'). hence
    # we require some minimum number of slashes and minimum
    # file name length
    'regex': FILE_NO_PERIODS,
    'noNum': True,
}]


# Attempts to resolve the root directory of the
# repository in which path resides (i.e. the current directory).
# both git and hg have commands for this, so let's just use those.
def getRepoPath():
    proc = subprocess.Popen(["git rev-parse --show-toplevel"],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            shell=True,
                            universal_newlines=True)

    (stdout, stderr) = proc.communicate()

    # If there was no error return the output
    if not stderr:
        logger.addEvent('using_git')
        return stdout

    proc = subprocess.Popen(["hg root"],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            shell=True)

    (stdout, stderr) = proc.communicate()

    # If there was no error return the output
    if not stderr:
        logger.addEvent('using_hg')
        return stdout

    # Not a git or hg repo, go with ~/www as a default
    logger.addEvent('used_outside_repo')
    return './'


PREPEND_PATH = getRepoPath().strip() + '/'


# returns a filename and (optional) line number
# if it matches
def matchLine(line, validateFileExists=False):
    if not validateFileExists:
        return matchLineImpl(line)
    result = matchLineImpl(line, withFileInspection=True)
    if not result:
        return result
    # ok now we are going to check if this result is an actual
    # file...
    (filePath, _, _) = result
    if not os.path.isfile(prependDir(filePath, withFileInspection=True)):
        return None
    return result


def matchLineImpl(line, withFileInspection=False):
    for regexConfig in REGEX_WATERFALL:
        regex = regexConfig['regex']
        if regexConfig.get('onlyWithFileInspection') and not withFileInspection:
            continue

        matches = regex.search(line)
        if not matches:
            continue
        unpackFunc = unpackMatchesNoNum if \
            regexConfig.get('noNum') else \
            lambda x: unpackMatches(x, numIndex=regexConfig.get('numIndex', 2))
        if not regexConfig.get('preferred_regex'):
            return unpackFunc(matches)

        # check the preferred_regex
        preferred_regex = regexConfig.get('preferred_regex')
        other_matches = preferred_regex.search(line)
        if not other_matches:
            return unpackFunc(matches)
        if other_matches.start() < matches.start():
            # we found a better result earlier, so return that
            return unpackFunc(other_matches)
        return unpackFunc(matches)
    # nothing matched at all
    return None


def prependDir(file, withFileInspection=False):
    if not file or len(file) < 2:
        return file

    if file[0] == '/':
        return file

    if file[0:4] == '.../':
        # these are the gross git abbreviated paths, so
        # return early since we cant do anything here
        return file

    if file[0:2] == '~/':
        # need to absolute it
        return os.path.expanduser(file)

    # if it starts with relative dirs (grep), then that's the easiest
    # because abspath will resolve this
    if file[0:2] == './' or file[0:3] == '../':
        return file

    # some peeps do forcedir and expand the path beforehand,
    # so lets check for that case here
    first = file.split(os.sep)[0]
    if first == 'home':
        # already absolute, easy
        return '/' + file

    if first in REPOS:
        return '~/' + file

    if '/' not in file:
        # assume current dir like ./
        return './' + file

    # git show and diff has a/stuff and b/stuff, so handle that. git
    # status never does this so we dont need to worry about relative dirs
    if file[0:2] == 'a/' or file[0:2] == 'b/':
        return PREPEND_PATH + file[2:]

    splitUp = file.split('/')
    if splitUp[0] == 'www':
        return PREPEND_PATH + '/'.join(splitUp[1:])

    if not withFileInspection:
        # hope
        return PREPEND_PATH + '/'.join(splitUp)
    # Alright we need to handle the case where git status returns
    # relative paths where every other git command returns paths relative
    # to the top-level dir. so lets see if PREPEND_PATH is not a file whereas
    # relative is...
    topLevelPath = PREPEND_PATH + '/'.join(splitUp)
    relativePath = './' + '/'.join(splitUp)
    if not os.path.isfile(topLevelPath) and os.path.isfile(relativePath):
        return relativePath
    return topLevelPath


def unpackMatchesNoNum(matches):
    return (matches.groups()[0], 0, matches)


def unpackMatches(matches, numIndex):
    groups = matches.groups()
    file = groups[0]
    num = 0 if groups[numIndex] is None else int(groups[numIndex])
    return (file, num, matches)
