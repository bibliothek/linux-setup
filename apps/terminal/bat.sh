#!/bin/bash
sudo apt install -y bat
# On some systems, the binary is named batcat, so we create a symlink
if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
  sudo ln -s /usr/bin/batcat /usr/local/bin/bat
fi
