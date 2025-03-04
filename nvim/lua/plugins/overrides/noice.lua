-- enable borders on pop-ups
return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- enable borders:
    opts.presets = opts.presets or {}
    opts.presets.lsp_doc_border = true
  end,
}
