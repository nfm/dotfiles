#!/usr/bin/env bash

# Determine the absolute path to this script's directory, so we can symlink to files in the directory it's located in
REPO=$(dirname -- $(readlink -f -- "$0"))

# Find the basename of the script itself, so we can exclude it from the list of files to symlink to
SCRIPT=$(basename -- "$0")

# Create symlinks to all non-hidden files and directories in the repo, excluding this script
FILES=$(ls $REPO | grep -v $SCRIPT)

echo "About to set up symlinks for the following files and directories:"
echo ${FILES}

read -p "Continue? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  for FILE in ${FILES}
  do
    SOURCE=$REPO/$FILE
    DEST=~/.$FILE

    if [[ -d $DEST ]]; then
      echo "[SKIP] ${DEST} is a directory, refusing to overwrite it"
    else
      ln --symbolic --interactive $SOURCE $DEST
    fi
  done
fi
