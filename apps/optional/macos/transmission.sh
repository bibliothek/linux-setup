#!/bin/bash

brew install transmission-cli

# The GUI is a cask, which errors out if already installed.
if brew list --cask transmission &> /dev/null; then
  echo "Transmission is already installed."
else
  brew install --cask transmission
fi
