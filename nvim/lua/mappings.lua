require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- oil.nvim
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- LSP code actions
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
