#!/bin/bash

# run.sh exports this; resolved here too so the script also works on its own.
# SUDO_USER matters because the run may be started with sudo.
ACTUAL_USER="${ACTUAL_USER:-${SUDO_USER:-${USER:-$(whoami)}}}"

# Membership in the sudo group is what grants sudo on Debian/Ubuntu.
if groups "$ACTUAL_USER" | grep -q '\bsudo\b'; then
  echo "User $ACTUAL_USER is already in sudo group."
else
  echo "Adding $ACTUAL_USER to sudo group..."
  sudo usermod -aG sudo "$ACTUAL_USER"
  echo "User added to sudo group. You may need to log out and log back in for changes to take effect."
fi
