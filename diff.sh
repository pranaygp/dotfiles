#!/usr/bin/env bash

# Use this file to selectively UPDATE folders from the home directory that
# might've changed compared to the files in this repo

set -euo pipefail

# Get the current script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List all files in the script's directory
files=$(
  find "$SCRIPT_DIR" -maxdepth 1 -type f \
    ! -name '.git' \
    ! -name "init/" \
    ! -name ".DS_Store" \
    ! -name "bootstrap.sh" \
    ! -name "diff.sh" \
    ! -name "README.md" \
    ! -name "LICENSE.txt"
)

echo Diffing changed files. ~ version will be on the left

# Loop through the files and compare timestamps with their corresponding files in the home directory
for file in $files; do
  filename=$(basename "$file")
  home_file="$HOME/$filename"

  if [ -f "$home_file" ]; then
    if ! cmp --silent "$file" "$home_file"; then
      echo "$filename has changed. Diffing..."
      code --diff "$home_file" "$file"
    fi

  fi
done
