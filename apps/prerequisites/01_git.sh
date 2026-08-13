#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo apt install -qq -y git
    ;;
  Darwin)
    # git comes from the Xcode Command Line Tools. /usr/bin/git is only a stub
    # until they are installed, so check for the tools rather than the binary.
    if xcode-select -p &> /dev/null; then
      echo "Xcode Command Line Tools already installed (provides git)."
    else
      echo "Installing Xcode Command Line Tools (provides git)..."
      xcode-select --install
      echo "Finish the Xcode Command Line Tools install, then re-run this setup."
      exit 1
    fi
    ;;
esac
