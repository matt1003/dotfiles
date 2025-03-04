-- write buffer with sudo
vim.api.nvim_create_user_command("SudoWrite", function()
  vim.cmd("w !sudo tee % > /dev/null")
  vim.cmd("edit!")
end, {})
vim.cmd("cabbrev sw SudoWrite")

-- delete buffer without closing window
vim.api.nvim_create_user_command("BufferDelete", function()
  if vim.bo.buftype == "" then
    require("snacks").bufdelete() -- Regular file: use snacks bufdelete to avoid closing the window
  else
    vim.cmd("bdelete") -- Special buffer (e.g., terminal, quickfix, etc): use normal bdelete
  end
end, {})
vim.cmd("cabbrev bd BufferDelete")
