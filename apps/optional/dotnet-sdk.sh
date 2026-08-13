#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo add-apt-repository -y ppa:dotnet/backports
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-10.0
    ;;
  Darwin)
    # The cask tracks the current SDK rather than a pinned major version.
    if brew list --cask dotnet-sdk &> /dev/null; then
      echo ".NET SDK is already installed."
    else
      brew install --cask dotnet-sdk
    fi
    ;;
esac
