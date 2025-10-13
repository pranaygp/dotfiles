#!/usr/bin/env bash

# Use this file to selectively UPDATE folders from the home directory that
# might've changed compared to the files in this repo

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the current script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List all files in the script's directory (top-level only)
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

echo -e "${BOLD}${CYAN}Diffing changed files. ~ version will be on the left${NC}"

# Loop through the top-level files and compare them with their corresponding files in the home directory
for file in $files; do
  # Get the relative path from SCRIPT_DIR
  rel_path="${file#$SCRIPT_DIR/}"
  home_file="$HOME/$rel_path"

  if [ -f "$home_file" ]; then
    if ! cmp --silent "$file" "$home_file"; then
      echo -e "${YELLOW}$rel_path${NC} has changed. Diffing..."
      code --diff "$home_file" "$file"
    fi
  fi
done

# For .config, treat home directory as source of truth
# Check all files in ~/.config and compare with repo
if [ -d "$HOME/.config" ]; then
  echo -e "\n${BOLD}${CYAN}Checking .config files (home dir as source of truth)...${NC}"

  # Array to track skipped directories
  skipped_dirs=()

  config_files=$(find "$HOME/.config" -type f ! -name ".DS_Store")

  for home_file in $config_files; do
    # Get the relative path from HOME
    rel_path="${home_file#$HOME/}"
    repo_file="$SCRIPT_DIR/$rel_path"

    # Check if this file is in a skipped directory
    should_skip=false
    if [ ${#skipped_dirs[@]} -gt 0 ]; then
      for skipped_dir in "${skipped_dirs[@]}"; do
        if [[ "$home_file" == "$skipped_dir"* ]]; then
          should_skip=true
          break
        fi
      done
    fi

    if [ "$should_skip" = true ]; then
      continue
    fi

    if [ -f "$repo_file" ]; then
      # File exists in both, compare them
      if ! cmp --silent "$home_file" "$repo_file"; then
        echo -e "${YELLOW}$rel_path${NC} has changed. Diffing..."
        code --diff "$home_file" "$repo_file"
      fi
    else
      # File exists in home but not in repo
      # Find the first missing directory in the hierarchy
      repo_dir=$(dirname "$repo_file")

      # Walk up the directory tree to find the first missing directory
      missing_dir=""
      current_dir="$repo_dir"
      while [ "$current_dir" != "$SCRIPT_DIR" ] && [ "$current_dir" != "/" ]; do
        if [ ! -d "$current_dir" ]; then
          missing_dir="$current_dir"
        else
          break
        fi
        current_dir=$(dirname "$current_dir")
      done

      # If we found a missing directory, ask about it
      if [ -n "$missing_dir" ]; then
        # Check if we've already asked about this directory or a parent
        already_asked=false
        if [ ${#skipped_dirs[@]} -gt 0 ]; then
          for skipped_dir in "${skipped_dirs[@]}"; do
            if [[ "$missing_dir" == "$skipped_dir"* ]] || [[ "$skipped_dir" == "$missing_dir"* ]]; then
              already_asked=true
              break
            fi
          done
        fi

        if [ "$already_asked" = false ]; then
          rel_dir="${missing_dir#$SCRIPT_DIR/}"
          echo -e "${BLUE}Directory ${YELLOW}$rel_dir/${NC}${BLUE} does not exist in repo.${NC}"
          read -p "Do you want to check files in this directory? (y/n): " -n 1 -r
          echo

          if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            # Add the corresponding home directory path to skipped dirs
            home_missing_dir="$HOME/${missing_dir#$SCRIPT_DIR/}"
            skipped_dirs+=("$home_missing_dir")
            echo -e "${RED}Skipping entire directory ${YELLOW}$rel_dir/.${NC}"
            continue
          fi
        fi
      fi

      # Ask about the specific file
      echo -e "${BLUE}File ${YELLOW}$rel_path${BLUE} exists in home but not in repo."
      read -p "Do you want to copy it to the repo? (y/n): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create parent directory if it doesn't exist
        mkdir -p "$(dirname "$repo_file")"
        cp "$home_file" "$repo_file"
        echo -e "${GREEN}✓ Copied $rel_path to repo.${NC}"
      else
        echo -e "${RED}✗ Skipped $rel_path.${NC}"
      fi
    fi
  done
fi
