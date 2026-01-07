#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

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

bash "$SCRIPT_DIR/install-optional.sh"

run_scripts "$SCRIPT_DIR/terminal" "terminal app scripts"

echo "All setup scripts executed."
