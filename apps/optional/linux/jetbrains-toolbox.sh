#!/bin/bash

# The Toolbox App is what manages the JetBrains IDEs themselves, so this
# installs Toolbox rather than any individual IDE.

if command -v jetbrains-toolbox &> /dev/null; then
  echo "JetBrains Toolbox is already installed."
  exit 0
fi

case "$(uname -m)" in
  x86_64) PLATFORM="linux" ;;
  aarch64 | arm64) PLATFORM="linuxARM64" ;;
  *)
    echo "Skipping JetBrains Toolbox: no build for $(uname -m)."
    exit 0
    ;;
esac

# Toolbox ships as an AppImage, which needs FUSE. The package is libfuse2 up to
# Ubuntu 22.04 and libfuse2t64 from 24.04 on.
sudo apt-get install -qq -y libfuse2 || sudo apt-get install -qq -y libfuse2t64 || echo "Note: no libfuse2 package available; Toolbox needs FUSE to start."

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading JetBrains Toolbox ($PLATFORM)..."
wget -q -O "$TMP_DIR/jetbrains-toolbox.tar.gz" "https://data.services.jetbrains.com/products/download?code=TBA&platform=$PLATFORM"
tar -xzf "$TMP_DIR/jetbrains-toolbox.tar.gz" -C "$TMP_DIR"

EXTRACTED=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)
if [ -z "$EXTRACTED" ]; then
  echo "Error: unexpected archive layout, no directory inside the tarball."
  exit 1
fi

# Copy the whole extracted tree: releases have shipped the binary both at the
# top level and under bin/, and newer ones carry files beside it.
sudo rm -rf /opt/jetbrains-toolbox
sudo mkdir -p /opt/jetbrains-toolbox
sudo cp -r "$EXTRACTED"/. /opt/jetbrains-toolbox/

BINARY=$(sudo find /opt/jetbrains-toolbox -maxdepth 2 -name jetbrains-toolbox -type f | head -n 1)
if [ -z "$BINARY" ]; then
  echo "Error: jetbrains-toolbox binary not found in the archive."
  exit 1
fi
sudo chmod 0755 "$BINARY"
sudo ln -sf "$BINARY" /usr/local/bin/jetbrains-toolbox

echo "Run 'jetbrains-toolbox' once to sign in and pick the IDEs to install."
