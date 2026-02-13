-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.nvdash = { load_on_startup = true }

M.ui = {
	tabufline = {
		bufwidth = 30,
	},

	statusline = {
		modules = {
			file = function()
				local stbufnr = function()
					return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
				end
				local icon = "󰈚"
				local path = vim.api.nvim_buf_get_name(stbufnr())
				local name = (path == "" and "Empty") or vim.fn.fnamemodify(path, ":.")

				if name ~= "Empty" then
					local devicons_present, devicons = pcall(require, "nvim-web-devicons")
					if devicons_present then
						local ft_icon = devicons.get_icon(name)
						icon = ft_icon or icon
					end
				end

				return "%#St_file# " .. icon .. " " .. name .. " %#St_file_sep#" .. ""
			end,
		},
	},
}

return M
