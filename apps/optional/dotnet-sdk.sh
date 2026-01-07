#!/bin/bash

sudo add-apt-repository -y ppa:dotnet/backports
sudo apt update -qq
sudo apt install -qq -y dotnet-sdk-9.0
