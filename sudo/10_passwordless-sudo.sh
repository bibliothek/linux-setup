#!/bin/bash

# run.sh exports this; resolved here too so the script also works on its own.
# SUDO_USER matters because the run may be started with sudo.
ACTUAL_USER="${ACTUAL_USER:-${SUDO_USER:-${USER:-$(whoami)}}}"

# /etc/sudoers.d is honoured on both: Ubuntu includes it by default, macOS via
# @includedir in /etc/sudoers. sudo skips any file in there whose name contains
# a '.' or ends in '~', so a username like "first.last" cannot be used as-is:
# the rule would be written and then silently ignored.
SUDOERS_FILE="/etc/sudoers.d/${ACTUAL_USER//[^[:alnum:]_-]/_}-nopasswd"

# Earlier runs of this script used the raw user name, so a dotted name left a
# file sudo ignores. Point it out rather than deleting anything under sudoers.d.
LEGACY_FILE="/etc/sudoers.d/$ACTUAL_USER-nopasswd"
if [ "$LEGACY_FILE" != "$SUDOERS_FILE" ] && [ -e "$LEGACY_FILE" ]; then
  echo "Note: $LEGACY_FILE is left over from an earlier run and is ignored by"
  echo "sudo because of the '.' in the name. Remove it with:"
  echo "  sudo rm '$LEGACY_FILE'"
fi

# Whether sudo really runs without a password. -k drops cached credentials
# first, -n makes sudo fail instead of prompting. Meaningless when the run was
# started as root, because then every sudo call succeeds either way.
passwordless_sudo_works() {
  [ "$(id -u)" -ne 0 ] && sudo -k -n true 2> /dev/null
}

if passwordless_sudo_works; then
  echo "Passwordless sudo already works for $ACTUAL_USER."
  exit 0
fi

echo "Configuring passwordless sudo for $ACTUAL_USER..."

# A malformed drop-in breaks sudo for every user, so validate before installing.
TMP_FILE=$(mktemp)
trap 'rm -f "$TMP_FILE"' EXIT
printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$ACTUAL_USER" > "$TMP_FILE"
if ! visudo -cqf "$TMP_FILE"; then
  echo "Error: the generated sudoers rule is not valid. Not installing it."
  exit 1
fi

sudo cp "$TMP_FILE" "$SUDOERS_FILE"
sudo chown root "$SUDOERS_FILE"
sudo chmod 0440 "$SUDOERS_FILE"

if [ "$(id -u)" -eq 0 ]; then
  echo "Wrote $SUDOERS_FILE (running as root, cannot verify it from here)."
elif passwordless_sudo_works; then
  echo "Passwordless sudo configured."
else
  echo "Error: wrote $SUDOERS_FILE but sudo still asks for a password."
  exit 1
fi
