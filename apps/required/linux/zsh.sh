#!/bin/bash

# On macOS zsh is the default shell and needs no install, which is why there is
# no counterpart to this script. Deliberately not brewed either: brew's zsh is
# not in /etc/shells, so chsh in config/shell.sh would fail.
sudo apt install -qq -y zsh
