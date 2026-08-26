#!/bin/bash

# The macOS cask drops the SDK outside the brew prefix and registers it through
# /etc/paths.d, which only reaches newly launched login shells - not this run.
# Homebrew also links it into its own bin, but fall back to the known location
# rather than silently skipping if that link is missing.
if ! command -v dotnet &> /dev/null && [ -x /usr/local/share/dotnet/dotnet ]; then
  PATH="/usr/local/share/dotnet:$PATH"
fi

# The SDK is optional, so only do anything when it was actually installed.
if ! command -v dotnet &> /dev/null; then
  echo "Skipping dotnet tools: no dotnet on PATH."
  exit 0
fi

echo "Configuring dotnet global tools..."

TOOL="Microsoft.Artifacts.CredentialProvider.NuGet.Tool"

# "dotnet tool install" errors out when the tool is already there, and the tool
# list prints package ids lower-cased.
if dotnet tool list --global | grep -qi "$TOOL"; then
  echo "$TOOL is already installed."
else
  dotnet tool install --global "$TOOL"
fi

# Global tools land in ~/.dotnet/tools, which is not on PATH by default.
case ":$PATH:" in
  *":$HOME/.dotnet/tools:"*) ;;
  *) echo "Note: add \$HOME/.dotnet/tools to PATH to run the tool." ;;
esac
