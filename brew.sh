#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

# Install zsh.
brew install zsh

# Switch to using brew-installed zsh as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/zsh"
fi;

# Install `wget`
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg
brew link --overwrite gnupg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install openssl@1.1
brew install screen
brew install php
brew install gmp

# Install other useful binaries.
brew install ffmpeg
brew install git
brew install git-lfs
brew install gh
brew install htop
brew install httpie
brew install imagemagick
brew install jq
brew install kafkacat
brew install librdkafka
brew install mosh
brew install nmap
brew install postgresql
brew install python@3.8
brew link --overwrite python@3.8
brew install redis
brew install skaffold
brew install speedtest
brew install tmux
brew install watchman
brew install wifi-password
brew install --HEAD jabley/wrk2/wrk2
brew install zstd

# Remove outdated versions from the cellar.
brew cleanup