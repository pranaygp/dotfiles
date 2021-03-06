#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master
git submodule update --init --recursive
git submodule update --recursive

function doIt() {
  rsync --exclude ".git/" \
    --exclude "init/" \
    --exclude ".DS_Store" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -avh --no-perms . ~

  rm -rf ~/.oh-my-zsh/custom
  cp -r ./init/oh-my-zsh/custom/ ~/.oh-my-zsh/custom/

  source ~/.profile
}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
  doIt
else
  read "REPLY?This may overwrite existing files in your home directory. Are you sure? (y/n) "
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
