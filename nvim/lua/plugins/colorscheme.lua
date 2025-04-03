-- configure colorscheme
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = true,
      overrides = {
        Bold = { bold = true },
        MatchParen = { link = "GruvboxYellowBold" },
        SpellBad = { link = "GruvboxBlueUnderline" },
        Pmenu = { bg = "" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
