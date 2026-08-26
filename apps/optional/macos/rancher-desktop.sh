#!/bin/bash

# The cask token is 'rancher', not 'rancher-desktop'.
if brew list --cask rancher &> /dev/null; then
  echo "Rancher Desktop is already installed."
else
  brew install --cask rancher
fi

# Keep Rancher Desktop from appending its own PATH block to the shell rcfiles
# the dotfiles repo owns. rdctl needs the app running, and is not on PATH here.
"$HOME/.rd/bin/rdctl" set --application.path-management-strategy manual 2> /dev/null \
  || echo "Skipped path management: Rancher Desktop is not running."
