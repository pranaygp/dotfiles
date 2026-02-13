#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

unset choice
if [ "$1" = "--force" -o "$1" = "-f" -o "$CODESPACES" ]; then
  :
else
  echo "Would you like to run ./diff.sh first to diff changes from your home directory (y/n)?: "
  read choice
  if [[ $choice =~ ^[Yy]$ ]]; then
    ./diff.sh
  fi
fi

unset doIt
git submodule update --init --recursive
git submodule update --recursive

function doIt() {
  # check if fnm is installed (required on macOS, optional on Linux)
  if [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS requires fnm (installed via homebrew)
    if ! command -v "fnm" &>/dev/null; then
      echo "fnm does not exist or is not executable."
      echo "Install fnm first - https://github.com/Schniz/fnm"
      echo "Or run the brew.sh script first on mac to install it via homebrew"
      exit 1
    fi
  else
    # On Linux, try to find fnm in common locations, but don't fail if not found
    if ! command -v "fnm" &>/dev/null; then
      # Try to add fnm to PATH if it exists in common locations
      if [ -d "$HOME/.local/share/fnm" ]; then
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env 2>/dev/null || true)"
      fi
    fi
  fi

  rsync --exclude ".git/" \
    --exclude "init/" \
    --exclude ".DS_Store" \
    --exclude "bootstrap.sh" \
    --exclude "diff.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    --exclude "brew.sh" \
    --exclude ".claude/settings.local.json" \
    --exclude ".config/gh/hosts.yml" \
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
