#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

unset choice
if [ "$1" = "--force" -o "$1" = "-f" -o "$CODESPACES" ]; then
  :
else
  read -p "Would you like to run ./update.sh first to sync in changes from your home directory (y/n)?: " choice
  if [[ $reply =~ ^[Yy]$ ]]; then
    ./update.sh
  fi
fi

unset doIt
git submodule update --init --recursive
git submodule update --recursive

function doIt() {
  rsync --exclude ".git/" \
    --exclude "init/" \
    --exclude ".DS_Store" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -avh --no-perms --update --times . ~

  rm -rf ~/.oh-my-zsh/custom
  cp -r ./init/oh-my-zsh/custom/ ~/.oh-my-zsh/custom/

  source ~/.profile
}

if [ "$1" = "--force" -o "$1" = "-f" -o "$CODESPACES" ]; then
  doIt
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " choice
  if [[ $reply =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
