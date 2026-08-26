#!/bin/bash

# The GUI app, which brings its own userspace networking stack. The 'tailscale'
# formula is the Linux-style tailscaled daemon instead, and the two conflict.
# Cask token was renamed from tailscale to tailscale-app.
if brew list --cask tailscale-app &> /dev/null; then
  echo "Tailscale is already installed."
else
  brew install --cask tailscale-app
fi

echo "Open Tailscale from /Applications and sign in to join your tailnet."
echo "Its CLI is at /Applications/Tailscale.app/Contents/MacOS/Tailscale."
