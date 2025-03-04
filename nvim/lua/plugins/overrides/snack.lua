-- configure current indent level highlighting
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.indent = {
      indent = {
        enabled = false,
      },
      scope = {
        enabled = true,
        only_current = true,
        hl = "GruvBoxYellow",
      },
      chunk = {
        enabled = true,
        only_current = true,
        hl = "GruvBoxYellow",
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = "─",
        },
      },
    }
  end,
  keys = {
    {
      "<leader>fw",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fW",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
  },
}
