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
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$("$(brew_bin)" shellenv)"
  # Linux needs brew's own gcc to build formulae; macOS uses the Xcode CLT.
  if [ "$(uname -s)" = "Linux" ]; then
    brew install gcc
  fi
fi
