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

-- Enable diagnostics pop-up:
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = {
        "BufLeave", -- Leave the buffer (e.g., :bn, :bp, :e <file>).
        "CursorMoved", -- Move cursor (prevents lingering float as you move).
        "InsertEnter", -- Enter insert mode (usually don't want float in your way).
        "FocusLost", -- Switch to another window or app.
        "WinLeave", -- Leave the current window (e.g., split navigation).
      },
    })
  end,
  desc = "Show diagnostic popup on hover",
})
