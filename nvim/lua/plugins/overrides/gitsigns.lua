-- set blame line, symbols, colors, and key mappings
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- set blame line:
    current_line_blame = true,
    current_line_blame_formatter = " <author> | <author_time:%d-%m-%Y> | <summary>",
    current_line_blame_opts = {
      delay = 300,
      virt_text_priority = 9999,
    },
    -- set symbols:
    signs = {
      add = { text = "┇" },
      change = { text = "┇" },
      delete = { text = "▽" },
      topdelete = { text = "△" },
      changedelete = { text = "┇" },
      untracked = { text = "┇" },
    },
    -- set staged symbols:
    signs_staged = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "▼" },
      topdelete = { text = "▲" },
      changedelete = { text = "┃" },
      untracked = { text = "┃" },
    },
  },
  keys = {
    {
      "<c-n>",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      mode = { "n" },
      desc = "Next Hunk",
    },
    {
      "<c-p>",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      mode = { "n" },
      desc = "Previous Hunk",
    },
    {
      "<leader>hu",
      function()
        require("gitsigns").reset_hunk()
      end,
      mode = { "n" },
      desc = "Remove Hunk",
    },
  },
  init = function()
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
  end,
}
