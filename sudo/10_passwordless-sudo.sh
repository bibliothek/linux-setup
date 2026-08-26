#!/bin/bash

# run.sh exports this; resolved here too so the script also works on its own.
# SUDO_USER matters because the run may be started with sudo.
ACTUAL_USER="${ACTUAL_USER:-${SUDO_USER:-${USER:-$(whoami)}}}"

# /etc/sudoers.d is honoured on both: Ubuntu includes it by default, macOS via
# @includedir in /etc/sudoers.
SUDOERS_FILE="/etc/sudoers.d/$ACTUAL_USER-nopasswd"

if [ -f "$SUDOERS_FILE" ]; then
  echo "Passwordless sudo already configured for $ACTUAL_USER."
else
  echo "Configuring passwordless sudo for $ACTUAL_USER..."
  echo "$ACTUAL_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDOERS_FILE" > /dev/null
  sudo chmod 0440 "$SUDOERS_FILE"
  echo "Passwordless sudo configured."
fi
