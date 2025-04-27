-- allow the visual put command to be dot-repeatable
vim.keymap.set("x", "p", '"xc<c-r>0<esc>', { noremap = true, silent = true })

-- use tab to move through buffers
vim.keymap.set("n", "<tab>", ":bn<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<s-tab>", ":bp<cr>", { noremap = true, silent = true })

--double escape to exit terminal insert mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- allow <ctrl-h|j|k|l> window switching when in terminal
vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", { noremap = true, silent = true })
