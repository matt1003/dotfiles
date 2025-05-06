-- configure current indent level highlighting
return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      indent = {
        enabled = false,
      },
      scope = {
        enabled = true,
        only_current = true,
        hl = "GruvboxYellow",
      },
      chunk = {
        enabled = true,
        only_current = true,
        hl = "GruvboxYellow",
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = "─",
        },
      },
    },
  },
  keys = {
    {
      "<leader>fw",
      function()
        Snacks.picker.grep()
      end,
      mode = { "n" },
      desc = "Grep",
    },
    {
      "<leader>fW",
      function()
        Snacks.picker.grep_word()
      end,
      mode = { "n", "x" },
      desc = "Visual selection or word",
    },
  },
}
