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
    return { "eslint_d" }
  end

  return {}
end

local function json_formatters(bufnr)
  if root_has(bufnr, { "biome.json", "biome.jsonc" }) then
    return { "biome" }
  end

  return {}
end

local project_formatting_only = {
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
  json = true,
  jsonc = true,
}

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = js_formatters,
    typescript = js_formatters,
    javascriptreact = js_formatters,
    typescriptreact = js_formatters,
    json = json_formatters,
    jsonc = json_formatters,
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = function(bufnr)
    return {
      timeout_ms = 500,
      -- Web files should only use a project-selected formatter on save.
      lsp_format = project_formatting_only[vim.bo[bufnr].filetype] and "never" or "fallback",
    }
  end,
}

return options
