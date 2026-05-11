#!/bin/bash

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono"

if fc-list | grep -qi "$FONT_NAME"; then
  echo "$FONT_NAME Nerd Font is already installed."
  exit 0
fi

mkdir -p "$FONT_DIR"

LATEST_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
  | grep "browser_download_url.*JetBrainsMono.zip" \
  | cut -d '"' -f 4)

TEMP_DIR=$(mktemp -d)
curl -fsSL -o "$TEMP_DIR/JetBrainsMono.zip" "$LATEST_URL"
unzip -qo "$TEMP_DIR/JetBrainsMono.zip" -d "$FONT_DIR"
rm -rf "$TEMP_DIR"

fc-cache -f "$FONT_DIR"
echo "$FONT_NAME Nerd Font installed."
