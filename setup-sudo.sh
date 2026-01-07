#!/bin/bash

# Add current user to sudo group if not already a member
if ! groups "$USER" | grep -q '\bsudo\b'; then
  echo "Adding $USER to sudo group..."
  sudo usermod -aG sudo "$USER"
  echo "User added to sudo group. You may need to log out and log back in for changes to take effect."
  echo "--------------------"
else
  echo "User $USER is already in sudo group."
  echo "--------------------"
fi

# Configure passwordless sudo for current user
SUDOERS_FILE="/etc/sudoers.d/$USER-nopasswd"
if [ ! -f "$SUDOERS_FILE" ]; then
  echo "Configuring passwordless sudo for $USER..."
  echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDOERS_FILE" > /dev/null
  sudo chmod 0440 "$SUDOERS_FILE"
  echo "Passwordless sudo configured."
  echo "--------------------"
else
  echo "Passwordless sudo already configured for $USER."
  echo "--------------------"
fi
