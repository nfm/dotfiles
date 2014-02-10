#!/usr/bin/env bash

cd "$(dirname "${0}")"

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  rsync -a --no-perms --out-format "%n%L" `git ls-files` ~
fi
