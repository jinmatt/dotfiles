local function root_has(bufnr, names)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local path = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()

  return vim.fs.root(path, names) ~= nil
end

local function js_formatters(bufnr)
  if root_has(bufnr, { "biome.json", "biome.jsonc" }) then
    return { "biome-organize-imports", "biome" }
  end

  if root_has(bufnr, {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
  }) then
    return { "prettierd", "prettier", stop_after_first = true }
  end

  if root_has(bufnr, {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
  }) then
    return { "eslint_d", "biome", stop_after_first = true }
  end

  return { "biome", stop_after_first = true }
end

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = js_formatters,
    typescript = js_formatters,
    javascriptreact = js_formatters,
    typescriptreact = js_formatters,
    json = { "biome" },
    jsonc = { "biome" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
