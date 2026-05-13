# Agent Notes

This is a personal dotfiles repo managed with Git and symlinks.

## Structure

- `nvim/` contains a NvChad-based Neovim config.
- `tmux/` contains tmux configuration.
- `ghostty/` contains Ghostty terminal configuration.
- `aerospace.toml` contains AeroSpace window manager configuration.
- `install.sh` installs or links dotfiles into their active config paths.

## General Guidance

- Keep changes minimal, targeted, and specific to the requested config area.
- Prefer editing files in this repo rather than active symlink targets or generated files.
- Do not edit plugin-managed directories such as `~/.local/share/nvim/lazy/`; override behavior from this repo instead.
- Check effective behavior with the relevant tool before changing config when possible.
- Be careful with unrelated local changes; this repo may have manual edits in progress.

## Symlinks

The Neovim config is installed by symlinking:

```text
~/.config/nvim -> ~/dotfiles/nvim
```

When editing through `~/.config/nvim`, changes should affect the tracked files under `nvim/`.
