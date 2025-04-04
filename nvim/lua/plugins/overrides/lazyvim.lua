-- set custom icons
return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.icons = opts.icons or {}
      -- set git icons
      opts.icons.git = vim.tbl_deep_extend("force", opts.icons.git or {}, {
        added = " ",
        modified = " ",
        removed = " ",
      })
      -- set diagnostics icons
      opts.icons.diagnostics = vim.tbl_deep_extend("force", opts.icons.diagnostics or {}, {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      })
    end,
  },
}
