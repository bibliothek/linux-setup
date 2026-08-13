#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo apt install -qq -y curl
    ;;
  Darwin)
    # curl ships with macOS; brew's is keg-only and would not be linked anyway.
    echo "curl is provided by macOS."
    ;;
esac
