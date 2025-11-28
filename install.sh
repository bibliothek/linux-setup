#!/bin/bash

# This script runs all scripts in the 'apps' subdirectories.

set -e # Exit immediately if a command exits with a non-zero status.

echo "Updating package list..."
sudo apt update
echo "--------------------"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Run prerequisites first
if [ -d "$SCRIPT_DIR/apps/prerequisites" ]; then
  echo "Running prerequisite scripts..."
  for script in "$SCRIPT_DIR/apps/prerequisites"/*.sh; do
    if [ -f "$script" ]; then
      echo "Running $script..."
      bash "$script"
      echo "$script finished."
      echo "--------------------"
    fi
  done
fi

# Run terminal app scripts
if [ -d "$SCRIPT_DIR/apps/terminal" ]; then
  echo "Running terminal app scripts..."
  for script in "$SCRIPT_DIR/apps/terminal"/*.sh; do
    if [ -f "$script" ]; then
      echo "Running $script..."
      bash "$script"
      echo "$script finished."
      echo "--------------------"
    fi
  done
fi

echo "All setup scripts executed."