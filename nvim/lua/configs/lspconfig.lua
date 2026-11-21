require("nvchad.configs.lspconfig").defaults()

-- TypeScript: use the TypeScript 7 native language server (`tsc --lsp`) when the
-- project has TS 7 (at the root, or in tools/ts7 like the Overflow monorepo).
-- Everywhere else, fall back to ts_ls (TypeScript 6). Only one attaches per project.
local ts_lockfiles = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
local ts7_cache = {}

local function ts_root(bufnr)
  return vim.fs.root(bufnr, { ts_lockfiles, { ".git" } }) or vim.fn.getcwd()
end

local function ts7_bin(root)
  if ts7_cache[root] == nil then
    ts7_cache[root] = false
    for _, rel in ipairs { "node_modules/.bin/tsc", "tools/ts7/node_modules/.bin/tsc" } do
      local bin = vim.fs.joinpath(root, rel)
      if vim.fn.executable(bin) == 1 then
        local out = vim.system({ bin, "--version" }, { text = true }):wait()
        local version = vim.version.parse(out.stdout or "")
        if out.code == 0 and version and version.major >= 7 then
          ts7_cache[root] = bin
          break
        end
      end
    end
  end
  return ts7_cache[root]
end

vim.lsp.config("tsc", {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ ts7_bin(config.root_dir), "--lsp", "--stdio" }, dispatchers)
  end,
  root_dir = function(bufnr, on_dir)
    local root = ts_root(bufnr)
    if ts7_bin(root) then
      on_dir(root)
    end
  end,
})

local ts_ls_root_dir = vim.lsp.config.ts_ls.root_dir
vim.lsp.config("ts_ls", {
  root_dir = function(bufnr, on_dir)
    if not ts7_bin(ts_root(bufnr)) then
      ts_ls_root_dir(bufnr, on_dir)
    end
  end,
})

local servers = { "html", "cssls", "ts_ls", "tsc", "biome", "tofu_ls" }
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
