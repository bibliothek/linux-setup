#!/bin/bash

# rustup is the canonical way to get Rust: it brings rustc, cargo, clippy and
# rustfmt, and keeps them updatable, which the brew formula does not.
if command -v rustup > /dev/null 2>&1; then
  echo "rustup is already installed, updating toolchains..."
  rustup update
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
