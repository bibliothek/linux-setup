#!/bin/bash

if brew list --cask signal &> /dev/null; then
  echo "Signal is already installed."
else
  brew install --cask signal
fi
