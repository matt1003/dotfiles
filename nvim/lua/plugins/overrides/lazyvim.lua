-- set custom icons
return {
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        diagnostics = {
          Error = " ",
          Warn = " ",
          Info = " ",
          Hint = " ",
        },
      },
    },
  },
}
