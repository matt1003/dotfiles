local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Disable spelling:
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("DisableSpelling"),
  pattern = "*",
  command = "if &bt != '' | setlocal nospell | endif",
})

-- Enable cursor line in the active window only:
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "FocusGained" }, {
  group = augroup("EnableCursorLine"),
  pattern = "*",
  command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  group = augroup("DisableCursorLine"),
  pattern = "*",
  command = "if &ft != 'neo-tree' | setlocal nocursorline | endif",
})
