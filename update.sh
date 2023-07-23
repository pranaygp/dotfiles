#!/usr/bin/env bash

# Use this file to selectively UPDATE folders from the home directory that
# might've changed compared to the files in this repo

set -euo pipefail


# Get the current script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List all files in the script's directory
files=$(find "$SCRIPT_DIR" -maxdepth 1 -type f \
  ! -name '.git' \
  ! -name "init/" \
  ! -name ".DS_Store" \
  ! -name "bootstrap.sh" \
  ! -name "update.sh" \
  ! -name "README.md" \
  ! -name "LICENSE.txt" \
)

# Loop through the files and compare timestamps with their corresponding files in the home directory
for file in $files; do
  filename=$(basename "$file")
  home_file="$HOME/$filename"

  if [ -f "$home_file" ]; then
    dotfiles_timestamp=$(date -r "$file" +%s)
    home_timestamp=$(date -r "$home_file" +%s)

    if [ $dotfiles_timestamp -gt $home_timestamp ]; then
      echo "File: $filename. dotfiles repo is newer. run \"source bootstrap.sh\" to update"
    elif [ $dotfiles_timestamp -lt $home_timestamp ]; then
      echo "File: $filename. home file version is newer."
      read -p "Want to see the difference? (y/n):" choice
      if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
        code --diff "$home_file" "$file" 
      else
        echo "Comparison skipped."
      fi
    fi
  fi
done