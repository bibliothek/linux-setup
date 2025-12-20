#!/bin/bash
PLATFORM=linux_amd64

sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_${PLATFORM} -O /usr/local/bin/yq 
sudo chmod +x /usr/local/bin/yq
