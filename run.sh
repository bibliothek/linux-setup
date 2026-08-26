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

# The scripts need the login user, not root: the run may be started with sudo,
# in which case USER is root.
export ACTUAL_USER="${SUDO_USER:-${USER:-$(whoami)}}"
if [ -z "$ACTUAL_USER" ]; then
  echo "Error: Could not determine username"
  exit 1
fi

# The only place that maps an OS to something: every script folder may hold an
# <os> subfolder whose scripts run on that OS only.
case "$(uname -s)" in
  Linux) OS_DIR="linux" ;;
  Darwin) OS_DIR="macos" ;;
  *)
    echo "Error: unsupported OS $(uname -s)."
    exit 1
    ;;
esac
export OS_DIR

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

# List the scripts of a folder that apply to this OS: the ones directly in it
# plus the ones in its <os> subfolder. Ordered by file name across both, so a
# numeric prefix can order an OS-specific script against a shared one.
list_scripts() {
  local dir="$1"
  local script
  {
    for script in "$dir"/*.sh "$dir/$OS_DIR"/*.sh; do
      if [ -f "$script" ]; then
        printf '%s\t%s\n' "$(basename "$script")" "$script"
      fi
    done
  } | sort -t "$(printf '\t')" -k1,1 | cut -f2
}

# Function to run all scripts in a directory
run_scripts() {
  local dir="$1"
  local description="$2"

  if [ ! -d "$dir" ]; then
    return
  fi

  echo "Running $description..."
  local script
  while IFS= read -r script; do
    [ -n "$script" ] || continue
    echo "Running $script..."
    load_brew
    bash "$script"
    echo "$script finished."
    echo "--------------------"
  done < <(list_scripts "$dir")
}

# Main installation flow
run_scripts "$SCRIPT_DIR/sudo" "sudo setup scripts"

run_scripts "$SCRIPT_DIR/apps/prerequisites" "prerequisite scripts"

load_brew
bash "$SCRIPT_DIR/apps/install-optional.sh"

run_scripts "$SCRIPT_DIR/apps/required" "required app scripts"

run_scripts "$SCRIPT_DIR/config" "configuration scripts"

echo "All setup scripts executed."
