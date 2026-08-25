#!/bin/bash

case "$(uname -s)" in
  Linux)
    sudo apt install -qq -y zsh
    ;;
  Darwin)
    # zsh is the default macOS shell. Deliberately not brewed: brew's zsh is
    # not in /etc/shells, so chsh in config/shell.sh would fail.
    echo "zsh is provided by macOS."
    ;;
esac

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh is already installed."
fi
