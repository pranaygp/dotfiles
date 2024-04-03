#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

unset choice
if [ "$1" = "--force" -o "$1" = "-f" -o "$CODESPACES" ]; then
  :
else
  echo "Would you like to run ./update.sh first to sync in changes from your home directory (y/n)?: "
  read choice
  if [[ $reply =~ ^[Yy]$ ]]; then
    ./update.sh
  fi
fi

unset doIt
git submodule update --init --recursive
git submodule update --recursive

function doIt() {
  if [ ! -d "${HOME}/.nvm/.git" ];
  then
      echo "Make sure to install nvm first"
      echo "You may use this command in a zsh shell - curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
      echo "Or check the nvm repo for the latest instructions"
      exit 1
  fi

  rsync --exclude ".git/" \
    --exclude "init/" \
    --exclude ".DS_Store" \
    --exclude "bootstrap.sh" \
    --exclude "update.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -avh --no-perms --update --times . ~

  if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Running .linux script"
    ./.linux
  fi

  rm -rf ~/.oh-my-zsh/custom
  cp -r ./init/oh-my-zsh/custom/ ~/.oh-my-zsh/custom/

  source ~/.profile
}

if [ "$1" = "--force" -o "$1" = "-f" -o "$CODESPACES" ]; then
  doIt
else
  echo "This may overwrite existing files in your home directory. Are you sure? (y/n): "
  read choice
  if [[ $choice =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
unset choice
