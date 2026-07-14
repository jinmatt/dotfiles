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

# Install Zed config
if [ -f "$DOTFILES_DIR/zed/settings.json" ] && [ -f "$DOTFILES_DIR/zed/keymap.json" ]; then
    mkdir -p "$CONFIG_DIR/zed"
    backup_and_link "$DOTFILES_DIR/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
    backup_and_link "$DOTFILES_DIR/zed/keymap.json" "$CONFIG_DIR/zed/keymap.json"
    echo "✓ Zed config installed"
else
    echo "Warning: zed settings or keymap not found in dotfiles"
fi

# Install aerospace config
if [ -f "$DOTFILES_DIR/aerospace.toml" ]; then
    backup_and_link "$DOTFILES_DIR/aerospace.toml" "$HOME/.aerospace.toml"
    echo "✓ AeroSpace config installed"
else
    echo "Warning: aerospace.toml not found in dotfiles"
fi

# Install ghostty config
if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    backup_and_link "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    echo "✓ Ghostty config installed"
else
    echo "Warning: ghostty/config not found in dotfiles"
fi

# Install tmux config
if [ -f "$DOTFILES_DIR/tmux/tmux.conf" ]; then
    mkdir -p "$CONFIG_DIR/tmux"
    backup_and_link "$DOTFILES_DIR/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"
    echo "✓ tmux config installed"
else
    echo "Warning: tmux/tmux.conf not found in dotfiles"
fi

# Install SSH config
if [ -f "$DOTFILES_DIR/ssh/config" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    backup_and_link "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    echo "✓ SSH config installed"
else
    echo "Warning: ssh/config not found in dotfiles"
fi

# Install 1Password SSH agent config
if [ -f "$DOTFILES_DIR/1Password/ssh/agent.toml" ]; then
    mkdir -p "$CONFIG_DIR/1Password/ssh"
    backup_and_link "$DOTFILES_DIR/1Password/ssh/agent.toml" "$CONFIG_DIR/1Password/ssh/agent.toml"
    echo "✓ 1Password SSH agent config installed"
else
    echo "Warning: 1Password/ssh/agent.toml not found in dotfiles"
fi

echo ""
echo "Installation complete!"
echo "Your dotfiles have been symlinked to their appropriate locations."
