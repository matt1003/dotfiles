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
    -- set staged symbols:
    opts.signs_staged = opts.signs_staged or {}
    opts.signs_staged.add = { text = "┃" }
    opts.signs_staged.change = { text = "┃" }
    opts.signs_staged.delete = { text = "▼" }
    opts.signs_staged.topdelete = { text = "▲" }
    opts.signs_staged.changedelete = { text = "┃" }
    opts.signs_staged.untracked = { text = "┃" }
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
    -- set highlighting:
    vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "GruvboxGreen" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { link = "GruvboxOrange" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GruvboxPurple" })
    -- set staged highlighting:
    vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { link = "GruvboxGreen" })
    vim.api.nvim_set_hl(0, "GitSignsStagedChange", { link = "GruvboxOrange" })
    vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsStagedChangedelete", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "GitSignsStagedUntracked", { link = "GruvboxPurple" })
    -- set blame line highlighting:
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "GruvboxBg3" })
    -- set key mappings:
    vim.api.nvim_set_keymap("n", "<c-n>", "<CMD>Gitsigns next_hunk<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<c-p>", "<CMD>Gitsigns prev_hunk<CR>", { silent = true })
    vim.api.nvim_set_keymap("n", "<leader>hu", "<CMD>Gitsigns reset_hunk<CR>", { silent = true })
  end,
}
