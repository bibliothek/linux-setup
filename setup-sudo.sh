#!/bin/bash

# Determine the actual username (works even when run with sudo)
ACTUAL_USER="${SUDO_USER:-${USER:-$(whoami)}}"

if [ -z "$ACTUAL_USER" ]; then
  echo "Error: Could not determine username"
  exit 1
fi

# Add current user to sudo group if not already a member
if ! groups "$ACTUAL_USER" | grep -q '\bsudo\b'; then
  echo "Adding $ACTUAL_USER to sudo group..."
  sudo usermod -aG sudo "$ACTUAL_USER"
  echo "User added to sudo group. You may need to log out and log back in for changes to take effect."
  echo "--------------------"
else
  echo "User $ACTUAL_USER is already in sudo group."
  echo "--------------------"
fi

# Configure passwordless sudo for current user
SUDOERS_FILE="/etc/sudoers.d/$ACTUAL_USER-nopasswd"
if [ ! -f "$SUDOERS_FILE" ]; then
  echo "Configuring passwordless sudo for $ACTUAL_USER..."
  echo "$ACTUAL_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDOERS_FILE" > /dev/null
  sudo chmod 0440 "$SUDOERS_FILE"
  echo "Passwordless sudo configured."
  echo "--------------------"
else
  echo "Passwordless sudo already configured for $ACTUAL_USER."
  echo "--------------------"
fi
