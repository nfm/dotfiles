#!/usr/bin/env bash

SCRIPT_DIR=`dirname "${0}"`
SCRIPT_FILE=`basename "${0}"`

cd "$SCRIPT_DIR"

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  rsync -a --no-perms --out-format "%n%L" --exclude .git --exclude "$SCRIPT_FILE" . ~/
fi
