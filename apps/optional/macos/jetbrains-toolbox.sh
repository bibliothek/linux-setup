#!/bin/bash

# The Toolbox App is what manages the JetBrains IDEs themselves, so this
# installs Toolbox rather than any individual IDE.
if brew list --cask jetbrains-toolbox &> /dev/null; then
  echo "JetBrains Toolbox is already installed."
else
  brew install --cask jetbrains-toolbox
fi
