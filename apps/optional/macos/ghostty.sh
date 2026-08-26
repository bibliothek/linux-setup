#!/bin/bash

if brew list --cask ghostty &> /dev/null; then
  echo "Ghostty is already installed."
else
  brew install --cask ghostty
fi
