require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers

-- Override LSP mappings to use Telescope instead of quickfix
local map = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = function(desc)
      return { buffer = bufnr, desc = "LSP " .. desc }
    end

    -- Override NvChad's default mappings with Telescope
    map("n", "gd", function()
      require("telescope.builtin").lsp_definitions()
    end, opts "Go to definition")

    map("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end, opts "Go to references")

    map("n", "gi", function()
      require("telescope.builtin").lsp_implementations()
    end, opts "Go to implementation")

    map("n", "gt", function()
      require("telescope.builtin").lsp_type_definitions()
    end, opts "Go to type definition")
  end,
}) 
