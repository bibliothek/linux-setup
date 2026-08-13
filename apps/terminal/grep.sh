#!/bin/bash

case "$(uname -s)" in
  Linux)
    # grep is usually pre-installed. This script ensures it is.
    sudo apt install -qq -y grep
    ;;
  Darwin)
    # macOS ships BSD grep (no -P). Homebrew builds GNU grep with
    # --program-prefix=g, so it installs as ggrep and leaves the system one
    # alone. Put grep/libexec/gnubin on PATH to get it as plain "grep".
    brew install grep
    echo "GNU grep installed as 'ggrep'."
    ;;
esac
