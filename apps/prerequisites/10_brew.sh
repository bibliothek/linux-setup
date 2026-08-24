#!/bin/bash

# Resolve brew across install prefixes: macOS arm64, macOS Intel, Linux.
brew_bin() {
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

if command -v brew &> /dev/null || brew_bin > /dev/null; then
  echo "Homebrew is already installed."
  eval "$("$(brew_bin)" shellenv)"
else
  echo "Installing Homebrew..."
  # Homebrew on Linux needs a toolchain and a few base utilities. Its installer
  # only prints them as a manual next step, and apt-get would then stop on a
  # confirmation prompt, so pull them in up front with -y.
  if [ "$(uname -s)" = "Linux" ]; then
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -qq -y build-essential procps curl file git
  fi
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$("$(brew_bin)" shellenv)"
  # Linux needs brew's own gcc to build formulae; macOS uses the Xcode CLT.
  if [ "$(uname -s)" = "Linux" ]; then
    brew install gcc
  fi
fi
