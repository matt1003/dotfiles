-- alternate between relative and absolute numbering
return {
  "matt1003/numbers.vim",
  init = function()
    vim.g.numbers_exclude_buftypes = {
      "acwrite",
      "help",
      "nofile",
      "nowrite",
      "quickfix",
      "terminal",
    }
  end,
}
