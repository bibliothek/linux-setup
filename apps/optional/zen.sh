#!/bin/bash

case "$(uname -s)" in
  Linux)
    # Zen publishes no apt repository; Flathub is the install route its own
    # Linux docs point at.
    sudo apt-get install -qq -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    if flatpak info app.zen_browser.zen &> /dev/null; then
      echo "Zen is already installed."
    else
      sudo flatpak install -y flathub app.zen_browser.zen
      echo "Note: log out and back in if Zen does not show up in the launcher yet."
    fi
    ;;
  Darwin)
    # The cask was renamed from zen-browser to zen.
    if brew list --cask zen &> /dev/null; then
      echo "Zen is already installed."
    else
      brew install --cask zen
    fi
    ;;
esac
