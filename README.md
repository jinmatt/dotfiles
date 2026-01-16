# Dotfiles

My personal dotfiles managed with Git and manual symlinks.

## Contents

- **nvim/** - Neovim configuration using NvChad
  - Lazy.nvim plugin manager
  - Custom keymappings and options
  - Plugin configurations in `lua/configs/`
- **aerospace.toml** - AeroSpace tiling window manager configuration

## Structure

```
~/dotfiles/
├── install.sh          # Installation script to set up symlinks
├── aerospace.toml     # AeroSpace window manager config
├── nvim/              # Neovim configuration
│   ├── init.lua       # Main config entry point
│   ├── lua/           # Lua configuration modules
│   │   ├── autocmds.lua
│   │   ├── chadrc.lua
│   │   ├── configs/   # Plugin-specific configs
│   │   ├── mappings.lua
│   │   ├── options.lua
│   │   └── plugins/   # Plugin specifications
│   ├── lazy-lock.json # Locked plugin versions
│   └── .stylua.toml   # Lua formatter config
└── README.md          # This file
```

## Installation

### Fresh Installation (New Machine)

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

   The script will:
   - Backup any existing configs (e.g., `~/.config/nvim` → `~/.config/nvim.backup.TIMESTAMP`)
   - Create symlinks from `~/.config/nvim` to `~/dotfiles/nvim`
   - Create symlink from `~/.aerospace.toml` to `~/dotfiles/aerospace.toml`

3. Open Neovim and let Lazy.nvim install plugins:
   ```bash
   nvim
   ```

### Manual Symlink Creation

If you prefer to create symlinks manually:

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)

# Create symlink for Neovim
ln -s ~/dotfiles/nvim ~/.config/nvim

# Create symlink for AeroSpace
ln -s ~/dotfiles/aerospace.toml ~/.aerospace.toml
```

## How Symlinks Work

This dotfiles setup uses symbolic links (symlinks) to connect your configuration files:

- **Source**: `~/dotfiles/nvim` (the actual files tracked by Git)
- **Target**: `~/.config/nvim` (where Neovim looks for config)
- **Symlink**: `~/.config/nvim` → `~/dotfiles/nvim`

When you edit files through `~/.config/nvim`, you're actually editing files in `~/dotfiles/nvim`, which means your changes are automatically tracked by Git.

### Verifying Symlinks

Check if symlinks are set up correctly:
```bash
ls -la ~/.config/nvim
# Should show: ~/.config/nvim -> /Users/jinmatt/dotfiles/nvim
```

## Adding More Dotfiles

To add other configuration files (e.g., `.zshrc`, `.tmux.conf`):

1. Copy the file to the dotfiles directory:
   ```bash
   cp ~/.zshrc ~/dotfiles/zshrc
   ```

2. Update `install.sh` to include the new file:
   ```bash
   backup_and_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
   ```

3. Commit the changes:
   ```bash
   git add zshrc install.sh
   git commit -m "Add zsh configuration"
   ```

## Neovim Configuration Details

### Plugin Manager

This configuration uses [Lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager, bootstrapped through NvChad.

### Customization

- **Keymappings**: `lua/mappings.lua`
- **Options**: `lua/options.lua`
- **Auto Commands**: `lua/autocmds.lua`
- **Plugin Configs**: `lua/configs/`
- **Plugin Specs**: `lua/plugins/`

### Plugin Lock File

The `lazy-lock.json` file is included in version control to ensure consistent plugin versions across machines. If you want to update plugins:

```bash
# In Neovim
:Lazy update

# Then commit the updated lock file
git add lazy-lock.json
git commit -m "Update plugin versions"
```

## Maintenance

### Updating Configs

1. Make changes to files in `~/dotfiles/` (or through the symlinks)
2. Commit changes:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Description of changes"
   ```

### Syncing Across Machines

```bash
# Pull latest changes
cd ~/dotfiles
git pull

# Neovim will automatically see the changes through the symlink
# Update plugins if lazy-lock.json changed:
nvim +Lazy sync +qa
```

## Troubleshooting

### Symlink Issues

If Neovim doesn't see your configs:

1. Verify the symlink exists:
   ```bash
   ls -la ~/.config/nvim
   ```

2. If broken, recreate it:
   ```bash
   rm ~/.config/nvim
   ln -s ~/dotfiles/nvim ~/.config/nvim
   ```

### Plugin Issues

If plugins aren't loading:

1. Remove plugin cache and reinstall:
   ```bash
   rm -rf ~/.local/share/nvim
   rm -rf ~/.local/state/nvim
   nvim
   ```

2. Check for errors:
   ```bash
   nvim +checkhealth
   ```

## Credits

- [NvChad](https://github.com/NvChad/NvChad) - Neovim configuration framework
- [LazyVim](https://github.com/LazyVim/starter) - Inspiration for NvChad starter
