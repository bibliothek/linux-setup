#!/bin/bash

if brew list --cask firefox &> /dev/null; then
  echo "Firefox is already installed."
else
  brew install --cask firefox
fi
