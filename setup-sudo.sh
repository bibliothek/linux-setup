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
