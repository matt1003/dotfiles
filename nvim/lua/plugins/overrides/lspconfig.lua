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
            local severity = diagnostic.severity or vim.diagnostic.severity.INFO
            local text = " " .. diagnostic_icons[severity] .. "  "
            local hl = "DiagnosticFloating" .. vim.diagnostic.severity[severity]
            return text, hl
          end,
          suffix = function(diagnostic)
            local source = diagnostic.source or "unknown"
            local code = diagnostic.code or "unknown"
            local text = " [" .. source:gsub("%.$", "") .. ":" .. code .. "] "
            local hl = "Comment"
            return text, hl
          end,
        },
      })
    end)
  end,
}
