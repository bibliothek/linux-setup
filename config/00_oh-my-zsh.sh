#!/bin/bash

# Shared step after the per-OS zsh install (apps/required/linux/zsh.sh on
# Linux, the system zsh on macOS): the installer refuses to run without a zsh
# on PATH.
#
# Must run before 10_dotfiles.sh: the installer rewrites ~/.zshrc, which
# dotfiles then replaces with a link to its own.
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
