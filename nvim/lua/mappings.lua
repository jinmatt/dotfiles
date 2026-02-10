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

-- Auto-session keymaps
map("n", "<leader>Ss", "<CMD>AutoSession search<CR>", { desc = "Search sessions" })
map("n", "<leader>Sd", "<CMD>AutoSession delete<CR>", { desc = "Delete session" })
map("n", "<leader>Sr", "<CMD>AutoSession restore<CR>", { desc = "Restore session" })
map("n", "<leader>Sa", "<CMD>AutoSession save<CR>", { desc = "Save session" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
