#!/bin/bash

# Determine the actual username (works even when run with sudo)
ACTUAL_USER="${SUDO_USER:-${USER:-$(whoami)}}"

if [ -z "$ACTUAL_USER" ]; then
  echo "Error: Could not determine username"
  exit 1
fi

# Make sure the user can sudo at all. The group and the tooling to change it
# differ per OS, so only the membership check is shared.
case "$(uname -s)" in
  Linux)
    if ! groups "$ACTUAL_USER" | grep -q '\bsudo\b'; then
      echo "Adding $ACTUAL_USER to sudo group..."
      sudo usermod -aG sudo "$ACTUAL_USER"
      echo "User added to sudo group. You may need to log out and log back in for changes to take effect."
      echo "--------------------"
    else
      echo "User $ACTUAL_USER is already in sudo group."
      echo "--------------------"
    fi
    ;;
  Darwin)
    # macOS grants sudo via the admin group, and there is no usermod. Adding a
    # user to admin needs admin rights already, so only report the state.
    if groups "$ACTUAL_USER" | grep -q '\badmin\b'; then
      echo "User $ACTUAL_USER is already in admin group."
      echo "--------------------"
    else
      echo "Error: $ACTUAL_USER is not in the admin group and cannot sudo."
      echo "Grant admin rights in System Settings > Users & Groups, then re-run."
      exit 1
    fi
    ;;
esac

# Configure passwordless sudo for current user. /etc/sudoers.d is honoured on
# both: Ubuntu includes it by default, macOS via @includedir in /etc/sudoers.
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
