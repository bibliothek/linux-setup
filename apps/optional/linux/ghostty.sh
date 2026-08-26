#!/bin/bash

# Ghostty is in the official Ubuntu repositories from 26.04 onwards. Older
# releases get it from the community PPA that Ghostty's docs point at for
# Ubuntu, which also tracks the newest upstream release.
if ! apt-cache policy ghostty 2>/dev/null | grep -q 'Candidate: [0-9]'; then
  sudo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu
  sudo apt-get update
fi
sudo apt-get install -qq -y ghostty
