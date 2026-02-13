require "nvchad.autocmds"

-- Auto-reload buffers when files change on disk (e.g., external editor, coding agent)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "silent! checktime",
})
