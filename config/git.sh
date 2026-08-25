#!/bin/bash

echo "Configuring Git..."

# Check if git user name is already set
if ! git config --global user.name &> /dev/null; then
    read -p "Enter your Git user name: " git_name
    git config --global user.name "$git_name"
fi

# Check if git email is already set
if ! git config --global user.email &> /dev/null; then
    read -p "Enter your Git email: " git_email
    git config --global user.email "$git_email"
fi

# Set default branch name to main
git config --global init.defaultBranch main

# Enable credential helper
git config --global credential.helper store

echo "Git configured:"
git config --global user.name
git config --global user.email

