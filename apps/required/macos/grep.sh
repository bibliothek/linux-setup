#!/bin/bash

# macOS ships BSD grep (no -P). Homebrew builds GNU grep with
# --program-prefix=g, so it installs as ggrep and leaves the system one alone.
# Put grep/libexec/gnubin on PATH to get it as plain "grep".
brew install grep
echo "GNU grep installed as 'ggrep'."
