#!/bin/bash

FONT_NAME="JetBrainsMono"

# No fontconfig on macOS; the cask drops the fonts in ~/Library/Fonts.
if brew list --cask font-jetbrains-mono-nerd-font &> /dev/null; then
  echo "$FONT_NAME Nerd Font is already installed."
else
  brew install --cask font-jetbrains-mono-nerd-font
  echo "$FONT_NAME Nerd Font installed."
fi
