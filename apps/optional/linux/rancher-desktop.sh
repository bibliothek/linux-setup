#!/bin/bash

set_path_management() {
  # Keep Rancher Desktop from appending its own PATH block to the shell rcfiles
  # the dotfiles repo owns. rdctl needs the app running, and is not on PATH here.
  "$HOME/.rd/bin/rdctl" set --application.path-management-strategy manual 2> /dev/null \
    || echo "Skipped path management: Rancher Desktop is not running."
}

if command -v rancher-desktop &> /dev/null; then
  echo "Rancher Desktop is already installed."
  set_path_management
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

set_path_management
