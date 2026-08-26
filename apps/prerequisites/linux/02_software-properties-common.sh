#!/bin/bash

# Provides add-apt-repository, which the PPA-based installers need.
sudo DEBIAN_FRONTEND=noninteractive apt install -qq -y software-properties-common
