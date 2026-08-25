#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo apt install -qq -y wl-clipboard
    ;;
  Darwin)
    # Wayland-only. macOS has pbcopy/pbpaste built in.
    echo "Skipping wl-clipboard on macOS (pbcopy/pbpaste are built in)."
    ;;
esac
