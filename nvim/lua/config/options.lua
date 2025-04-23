-- user space as the leader
vim.api.nvim_set_keymap("", "<space>", "<nop>", { silent = true, noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- configure white-space characters
vim.opt.listchars = { tab = "»―", space = "·", nbsp = "⚬", eol = "↵" }

-- cursor line always vertically centered
vim.opt.scrolloff = 999

-- use the system clipboard
vim.opt.clipboard = "unnamed,unnamedplus"

-- enable spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- terminal settings
vim.opt.shell = "/usr/local/bin/zsh"
