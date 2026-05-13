# Neovim Agent Notes

This directory contains a NvChad-based Neovim config.

## Active Config

The active Neovim config path is:

```text
~/.config/nvim
```

It is expected to point at this repo's `nvim/` directory.

## Keymap Locations

Keymaps may be defined in multiple places:

- `lua/mappings.lua`
- `lua/configs/lspconfig.lua`
- `lua/plugins/init.lua`
- `lua/plugins/opencode.lua`
- Inherited NvChad defaults at `~/.local/share/nvim/lazy/NvChad/lua/nvchad/mappings.lua`

Do not edit files under `~/.local/share/nvim/lazy/`; those are plugin-managed. Override defaults from this repo instead.

## NvChad Defaults

`lua/mappings.lua` loads NvChad defaults with:

```lua
require "nvchad.mappings"
```

Known inherited mappings:

```text
<leader>n   toggle absolute line numbers
<leader>rn  toggle relative line numbers
```

Leader is space.

## Headless Checks

Mappings are loaded through `vim.schedule` in `init.lua`, so force-load mappings when checking keymaps headlessly:

```sh
nvim --headless +'lua require("mappings"); print(vim.inspect(vim.fn.maparg("<leader>rn", "n", false, true)))' +qa
```

Check line-number state with:

```sh
nvim --headless +'set number? relativenumber?' +qa
```
