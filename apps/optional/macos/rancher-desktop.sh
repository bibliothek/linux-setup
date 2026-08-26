#!/bin/bash

# The cask token is 'rancher', not 'rancher-desktop'.
if brew list --cask rancher &> /dev/null; then
  echo "Rancher Desktop is already installed."
else
  brew install --cask rancher
fi
