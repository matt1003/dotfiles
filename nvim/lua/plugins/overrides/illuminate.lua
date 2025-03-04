-- disable for specified file types
return {
  "RRethy/vim-illuminate",
  opts = function(_, opts)
    -- disable files:
    opts.filetypes_denylist = {
      "dashboard",
      "help",
      "neo-tree",
    }
  end,
  config = function(_, opts)
    require("illuminate").configure(opts)
    -- Enable illuminate in the active window only:
    vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "FocusGained" }, {
      pattern = "*",
      command = "IlluminateResumeBuf",
    })
    vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
      pattern = "*",
      command = "IlluminatePauseBuf",
    })
  end,
}
