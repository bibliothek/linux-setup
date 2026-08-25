#!/bin/bash

echo "Configuring default shell..."

# Check if zsh is already the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        echo "Default shell changed to zsh. Please log out and back in for changes to take effect."
else
    echo "zsh is already the default shell."
fi

