#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

bash "$SCRIPT_DIR/setup-sudo.sh"
bash "$SCRIPT_DIR/apps/install.sh"
