#!/bin/bash

echo "Configuring dotfiles..."

DOTFILES_DIR="$HOME/dotfiles"

# Check if dotfiles directory already exists
if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory already exists at $DOTFILES_DIR"

    # Check if it's a git repository
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo "Pulling latest changes..."
        git -C "$DOTFILES_DIR" pull
    else
        echo "Directory exists but is not a git repository. Removing and cloning..."
        rm -rf "$DOTFILES_DIR"
        git clone https://github.com/bibliothek/dotfiles.git "$DOTFILES_DIR"
    fi
else
    echo "Cloning dotfiles from https://github.com/bibliothek/dotfiles..."
    git clone https://github.com/bibliothek/dotfiles.git "$DOTFILES_DIR"
fi

echo "Running dotfiles install script..."
bash "$DOTFILES_DIR/install"
echo "Dotfiles installed successfully!"

