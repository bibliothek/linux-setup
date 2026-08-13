#!/bin/bash
brew install tmux

TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if tpm directory already exists
if [ -d "$TPM_DIR" ]; then
    echo "tpm directory already exists at $TPM_DIR"
else
    echo "Cloning tpm from https://github.com/tmux-plugins/tpm..."
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
