local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN] = "",
  [vim.diagnostic.severity.INFO] = "",
  [vim.diagnostic.severity.HINT] = "",
}
return {
  "neovim/nvim-lspconfig",
  opts = function()
    vim.schedule(function()
      vim.diagnostic.config({
        virtual_text = {
          source = false,
          spacing = 1,
          prefix = function(diagnostic)
            return diagnostic_icons[diagnostic.severity] .. " "
          end,
        },
        float = {
          source = false,
          border = "rounded",
          header = "",
          prefix = function(diagnostic)
            return " " .. diagnostic_icons[diagnostic.severity] .. "  ",
              "DiagnosticFloating" .. vim.diagnostic.severity[diagnostic.severity]
          end,
          suffix = function(diagnostic)
            return " [" .. diagnostic.source:gsub("%.$", "") .. ":" .. diagnostic.code .. "] ", "Comment"
          end,
        },
      })
    end)
  end,
}
