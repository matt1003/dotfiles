-- configure colorscheme

-- muted:
local DiagnosticMutedError = "#8f423d"
local DiagnosticMutedWarn = "#99732e"
local DiagnosticMutedInfo = "#556462"
local DiagnosticMutedHint = "#56735f"

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
        SpellBad = { link = "GruvboxPurpleUnderline" },
        SpellCap = { link = "GruvboxPurpleUnderline" },
        Pmenu = { bg = "" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "gruvbox"
    end,
  },
}
