#!/bin/bash

# The cask tracks the current SDK rather than a pinned major version.
if brew list --cask dotnet-sdk &> /dev/null; then
  echo ".NET SDK is already installed."
else
  brew install --cask dotnet-sdk
fi
