#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Keep every brew call unattended: NONINTERACTIVE makes brew assume the default
# answer instead of prompting (including the sudo prompt for casks), and the
# hints/auto-update noise is not useful in a scripted run.
export NONINTERACTIVE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

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
bash "$SCRIPT_DIR/setup-sudo.sh"

case "$(uname -s)" in
  Linux)
    echo "Updating package list..."
    sudo apt update -qq
    echo "--------------------"
    ;;
  Darwin)
    # Nothing to refresh yet: brew is installed by the prerequisite scripts.
    ;;
esac

run_scripts "$SCRIPT_DIR/apps/prerequisites" "prerequisite scripts"

load_brew
bash "$SCRIPT_DIR/apps/install-optional.sh"

run_scripts "$SCRIPT_DIR/apps/terminal" "terminal app scripts"

run_scripts "$SCRIPT_DIR/config" "configuration scripts"

echo "All setup scripts executed."
