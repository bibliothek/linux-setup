#!/bin/bash

echo "Configuring Neovim..."

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Check if neovim config directory already exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "Neovim config directory already exists at $NVIM_CONFIG_DIR"

    # Check if it's a git repository
    if [ -d "$NVIM_CONFIG_DIR/.git" ]; then
        echo "Pulling latest changes..."
        git -C "$NVIM_CONFIG_DIR" pull
    else
        echo "Directory exists but is not a git repository. Removing and cloning..."
        rm -rf "$NVIM_CONFIG_DIR"
        git clone https://github.com/bibliothek/nvim.git "$NVIM_CONFIG_DIR"
        echo "Neovim configuration installed successfully!"
    fi
else
    echo "Cloning nvim configuration from https://github.com/bibliothek/nvim..."
    git clone https://github.com/bibliothek/nvim.git "$NVIM_CONFIG_DIR"
    echo "Neovim configuration installed successfully!"
fi
