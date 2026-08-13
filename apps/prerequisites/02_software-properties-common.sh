#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo DEBIAN_FRONTEND=noninteractive apt install -qq -y software-properties-common
    ;;
  Darwin)
    # Provides add-apt-repository; no equivalent or need on macOS.
    echo "Skipping software-properties-common on macOS."
    ;;
esac
