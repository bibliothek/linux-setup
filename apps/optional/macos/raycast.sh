#!/bin/bash

# macOS only: Raycast has no Linux build, which is why there is no counterpart
# in optional/linux.
if brew list --cask raycast &> /dev/null; then
  echo "Raycast is already installed."
else
  brew install --cask raycast
fi
