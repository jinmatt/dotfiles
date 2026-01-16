#!/bin/bash

# Dotfiles installation script
# This script creates symlinks from your home directory to the dotfiles repo

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "Installing dotfiles from $DOTFILES_DIR"

# Function to backup and symlink
backup_and_link() {
    local source=$1
    local target=$2
    
    # Check if target exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing $target to $backup_name"
        mv "$target" "$backup_name"
    elif [ -L "$target" ]; then
        echo "Removing existing symlink at $target"
        rm "$target"
    fi
    
    # Create symlink
    echo "Creating symlink: $target -> $source"
    ln -s "$source" "$target"
}

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

# Install nvim config
if [ -d "$DOTFILES_DIR/nvim" ]; then
    backup_and_link "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
    echo "✓ Neovim config installed"
else
    echo "Warning: nvim directory not found in dotfiles"
fi

echo ""
echo "Installation complete!"
echo "Your dotfiles have been symlinked to their appropriate locations."
