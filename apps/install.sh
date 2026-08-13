#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Put Homebrew on PATH. Called before every script because brew is installed
# mid-run, and each script runs in its own shell that inherits PATH from here.
load_brew() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done
  return 0
}

# Function to run all scripts in a directory
run_scripts() {
  local dir="$1"
  local description="$2"

  if [ ! -d "$dir" ]; then
    return
  fi

  echo "Running $description..."
  for script in "$dir"/*.sh; do
    [ -f "$script" ] || continue
    echo "Running $script..."
    load_brew
    bash "$script"
    echo "$script finished."
    echo "--------------------"
  done
}

# Main installation flow
echo "Updating package list..."
sudo apt update -qq
echo "--------------------"

run_scripts "$SCRIPT_DIR/prerequisites" "prerequisite scripts"

load_brew
bash "$SCRIPT_DIR/install-optional.sh"

run_scripts "$SCRIPT_DIR/terminal" "terminal app scripts"

run_scripts "$SCRIPT_DIR/config" "configuration scripts"

echo "All setup scripts executed."
