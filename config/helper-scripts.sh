#!/bin/bash

echo "Configuring helper-scripts..."

HELPER_SCRIPTS_DIR="$HOME/source/repos/helper-scripts"

# Check if helper-scripts directory already exists
if [ -d "$HELPER_SCRIPTS_DIR" ]; then
    echo "helper-scripts directory already exists at $HELPER_SCRIPTS_DIR"

    # Check if it's a git repository
    if [ -d "$HELPER_SCRIPTS_DIR/.git" ]; then
        echo "Pulling latest changes..."
        git -C "$HELPER_SCRIPTS_DIR" pull
    else
        echo "Directory exists but is not a git repository. Removing and cloning..."
        rm -rf "$HELPER_SCRIPTS_DIR"
        git clone https://github.com/bibliothek/helper-scripts.git "$HELPER_SCRIPTS_DIR"
    fi
else
    echo "Cloning helper-scripts from https://github.com/bibliothek/helper-scripts..."
    mkdir -p "$(dirname "$HELPER_SCRIPTS_DIR")"
    git clone https://github.com/bibliothek/helper-scripts.git "$HELPER_SCRIPTS_DIR"
fi

echo "helper-scripts cloned successfully!"
