#!/usr/bin/env bash

SCRIPT_DIR=`dirname "${0}"`

cd "$SCRIPT_DIR"

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  rsync -a --no-perms --out-format "%n%L" --exclude .git --exclude bootstrap.sh --exclude import.sh . ~/
fi
