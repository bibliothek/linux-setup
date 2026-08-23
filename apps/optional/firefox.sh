#!/bin/bash

MOZILLA_KEY_FINGERPRINT="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

case "$(uname -s)" in
  Linux)
    # Ubuntu's own firefox package is a transitional package for the snap, so
    # install from Mozilla's APT repository instead. Written with tee (not
    # tee -a) so re-running does not duplicate the source entry.
    KEYRING="/etc/apt/keyrings/packages.mozilla.org.asc"
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee "$KEYRING" > /dev/null

    # Only trust the repository if the key really is the one Mozilla publishes.
    if ! gpg --show-keys --with-fingerprint --with-colons "$KEYRING" 2>/dev/null | grep -q "^fpr.*:$MOZILLA_KEY_FINGERPRINT:"; then
      echo "Error: $KEYRING does not match Mozilla's published fingerprint."
      echo "Expected $MOZILLA_KEY_FINGERPRINT. Refusing to add the repository."
      sudo rm -f "$KEYRING"
      exit 1
    fi

    echo "deb [signed-by=$KEYRING] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

    # Pin the Mozilla packages above the distro ones, otherwise apt keeps
    # resolving firefox to the snap transitional package.
    printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

    sudo apt-get update -qq
    sudo apt-get install -qq -y firefox

    if snap list firefox &> /dev/null; then
      echo "Note: the Firefox snap is still installed and also provides a"
      echo "firefox command. Remove it with 'sudo snap remove firefox' if the"
      echo "deb build should be the only one."
    fi
    ;;
  Darwin)
    if brew list --cask firefox &> /dev/null; then
      echo "Firefox is already installed."
    else
      brew install --cask firefox
    fi
    ;;
esac
