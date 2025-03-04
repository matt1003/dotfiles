-- do not overwrite the unnamed register when pasting in visual mode
-- TODO: This does not work:
vim.api.nvim_set_keymap("v", "p", "P", { noremap = true })

-- use tab to move through buffers
vim.api.nvim_set_keymap("n", "<tab>", ":bn<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<s-tab>", ":bp<cr>", { silent = true, noremap = true })

--double escape to exit terminal insert mode
vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- allow <ctrl-h|j|k|l> window switching when in terminal
vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", { noremap = true, silent = true })
