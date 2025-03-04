-- set blame line, symbols, colors, and key mappings
return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- set blame line:
    opts.current_line_blame = true
    opts.current_line_blame_formatter = " <author> | <author_time:%d-%m-%Y> | <summary>"
    opts.current_line_blame_opts = opts.current_line_blame_opts or {}
    opts.current_line_blame_opts.delay = 300
    opts.current_line_blame_opts.virt_text_priority = 9999
    -- set symbols:
    opts.signs = opts.signs or {}
    opts.signs.add = { text = "┇" }
    opts.signs.change = { text = "┇" }
    opts.signs.delete = { text = "▽" }
    opts.signs.topdelete = { text = "△" }
    opts.signs.changedelete = { text = "┇" }
    opts.signs.untracked = { text = "┇" }
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
    -- set highlighting:
    vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GruvBoxGreen" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvBoxOrange" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "GruvBoxRed" })
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GruvBoxRed" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GruvBoxRed" })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GruvboxPurple" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "GruvboxBg3" })
    -- set key mappings:
    vim.api.nvim_set_keymap("n", "<c-n>", "<CMD>Gitsigns next_hunk<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<c-p>", "<CMD>Gitsigns prev_hunk<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>hu", "<CMD>Gitsigns reset_hunk<CR>", { silent = true })
  end,
}
