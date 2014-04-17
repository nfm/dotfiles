#!/usr/bin/env bash

cd "$(dirname "$0")"
SCRIPT_DIR=`pwd`

# Find dot directories in the repo, exclude '.' and '.git'
DIRS=$(find "$SCRIPT_DIR" -maxdepth 1 -type d -name \\.* -printf '%f\n' | egrep -v '^.$|.git')

# Find dot files in the repo
FILES=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name \\.* -printf '%f\n')
FILES=$FILES

echo "Directories to copy:"
echo $DIRS
echo
echo "Files to copy:"
echo $FILES
echo

export DIRS
export FILES
read -p "This may overwrite existing files in this directory. Are you sure? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd $HOME && cp -rf `echo "$DIRS"` $SCRIPT_DIR
  cd $HOME && cp -f `echo "$FILES"` $SCRIPT_DIR
fi
