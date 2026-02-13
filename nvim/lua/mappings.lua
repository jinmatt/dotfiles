require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope resume last search
map("n", "<leader>fr", "<CMD>Telescope resume<CR>", { desc = "Resume last search" })

-- Telescope live grep in a specific directory
map("n", "<leader>fD", function()
  local dir = vim.fn.input("Directory: ", "", "dir")
  if dir ~= "" then
    require("telescope.builtin").live_grep({ search_dirs = { dir } })
  end
end, { desc = "Live grep in directory" })

-- Telescope live grep filtered by file extension
map("n", "<leader>fE", function()
  local ext = vim.fn.input("File extension: ")
  if ext ~= "" then
    require("telescope.builtin").live_grep({ glob_pattern = "*." .. ext })
  end
end, { desc = "Live grep by file extension" })

-- Telescope search all keymaps
map("n", "<leader>fk", "<CMD>Telescope keymaps<CR>", { desc = "Search keymaps" })

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

-- DAP (Debug Adapter Protocol)
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Debug conditional breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Debug continue" })
map("n", "<leader>do", function() require("dap").step_over() end, { desc = "Debug step over" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Debug step into" })
map("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Debug step out" })
map("n", "<leader>dr", function() require("dap").restart() end, { desc = "Debug restart" })
map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Debug terminate" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Debug toggle UI" })
map("n", "<leader>de", function() require("dapui").eval() end, { desc = "Debug eval expression" })
map("v", "<leader>de", function() require("dapui").eval() end, { desc = "Debug eval selection" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Debug run last" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
