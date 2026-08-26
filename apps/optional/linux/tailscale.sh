#!/bin/bash

if command -v tailscale &> /dev/null; then
  echo "Tailscale is already installed."
else
  # Tailscale's own installer picks the apt repository matching the running
  # distribution and release, installs the package and starts tailscaled.
  # Doing it by hand would mean hardcoding a distro codename here.
  curl -fsSL https://tailscale.com/install.sh | sh
fi

echo "Run 'sudo tailscale up' to connect this machine to your tailnet."
