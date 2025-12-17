#!/bin/bash
PLATFORM=linux_amd64

wget https://github.com/mikefarah/yq/releases/latest/download/yq_${PLATFORM} -O /usr/local/bin/yq &&\
    chmod +x /usr/local/bin/yq
