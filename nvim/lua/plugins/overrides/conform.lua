-- enable biome organize imports
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      javascript = { "biome", "biome-check", "biome-organize-imports" },
      typescript = { "biome", "biome-check", "biome-organize-imports" },
      vue = { "biome", "biome-check", "biome-organize-imports" },
    })
  end,
}
