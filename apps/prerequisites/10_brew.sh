#!/bin/bash

# Check if brew is already installed
if command -v brew &> /dev/null; then
  echo "Homebrew is already installed."
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
fi
