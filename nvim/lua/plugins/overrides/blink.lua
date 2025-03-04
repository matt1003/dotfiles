-- set <tab> for auto-completion and enable borders on pop-ups
return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    -- set rounded border on selection menu pop-up:
    opts.completion.menu = vim.tbl_deep_extend("force", opts.completion.menu or {}, {
      border = "rounded",
    })
    -- set rounded border on documentation pop-up:
    opts.completion.documentation = vim.tbl_deep_extend("force", opts.completion.documentation or {}, {
      window = { border = "rounded" },
    })
    -- set rounded border on signature pop-up:
    opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
      window = { border = "rounded" },
    })
    -- set <tab> for auto-completion:
    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      preset = "super-tab",
    })
  end,
  init = function()
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Search" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "GruvboxBg3" })
  end,
}
