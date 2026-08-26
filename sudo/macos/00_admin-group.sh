#!/bin/bash

# run.sh exports this; resolved here too so the script also works on its own.
# SUDO_USER matters because the run may be started with sudo.
ACTUAL_USER="${ACTUAL_USER:-${SUDO_USER:-${USER:-$(whoami)}}}"

# macOS grants sudo via the admin group, and there is no usermod. Adding a user
# to admin needs admin rights already, so only report the state.
if groups "$ACTUAL_USER" | grep -q '\badmin\b'; then
  echo "User $ACTUAL_USER is already in admin group."
else
  echo "Error: $ACTUAL_USER is not in the admin group and cannot sudo."
  echo "Grant admin rights in System Settings > Users & Groups, then re-run."
  exit 1
fi
