#!/bin/bash

case "$(uname -s)" in
  Linux)
    if command -v rancher-desktop &> /dev/null; then
      echo "Rancher Desktop is already installed."
      exit 0
    fi

    # Upstream only publishes an amd64 .deb.
    case "$(uname -m)" in
      x86_64) ;;
      *)
        echo "Skipping Rancher Desktop: no Linux build for $(uname -m)."
        exit 0
        ;;
    esac

    # Rancher Desktop ships through the openSUSE build service repo that the
    # official docs point at for Debian/Ubuntu.
    curl -fsSL https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key \
      | gpg --dearmor | sudo tee /usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg > /dev/null
    echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' \
      | sudo tee /etc/apt/sources.list.d/isv-rancher-stable.list > /dev/null

    sudo apt-get update -qq
    sudo apt-get install -qq -y rancher-desktop
    ;;
  Darwin)
    if brew list --cask rancher &> /dev/null; then
      echo "Rancher Desktop is already installed."
    else
      brew install --cask rancher
    fi
    ;;
esac
