-- use custom lualine
local Util = require("lazyvim.util")
local my_icons = { "", "", "", "󱙝", "", "", "󰣙", "󰻖", "", "󰼂", "󰑮", "󱙴" }

return {
  "matt1003/lualine.nvim",
  lazy = false,
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require
    local icons = require("lazyvim.config").icons
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        -- (A b c ... x y z): Mode
        lualine_a = { "mode" },
        -- (a B c ... x y z): Current Directory | Current Branch
        lualine_b = {
          Util.lualine.root_dir({ icon = "󱉭" }),
          "branch",
        },
        -- (a b C ... x y z): Current File | Git Changes Icons | Errors/Warnings Icons
        lualine_c = {
          Util.lualine.pretty_path({ relative = "root", modified_hl = "GruvBoxOrange" }),
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        -- (a b c ... X y z): Search Count + Line Number + Column Number + File Percentage
        lualine_x = {
          function()
            if vim.v.hlsearch == 0 then
              return ""
            end
            local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
            if not ok or next(result) == nil then
              return ""
            end
            local denominator = math.min(result.total, result.maxcount)
            return string.format("%d/%d", result.current, denominator)
          end,
          function()
            local line = vim.fn.line(".")
            local col = vim.fn.charcol(".")
            local total = vim.fn.line("$")
            return line .. " " .. col + 1 .. " " .. math.floor(line / total * 100) .. "%%"
          end,
        },
        -- (a b c ... x Y z): Formatters + LSPs
        lualine_y = {
          function()
            local names = {}
            local clients = require("conform").list_formatters_to_run(vim.api.nvim_get_current_buf())
            if next(clients) then
              for _, client in pairs(clients) do
                table.insert(names, client.name)
              end
            end
            return table.concat(names, " | ")
          end,
          function()
            local names = {}
            local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
            if next(clients) then
              for _, client in pairs(clients) do
                table.insert(names, client.name)
              end
            end
            return table.concat(names, " | ")
          end,
        },
        -- (a b c ... x y Z): File Type
        lualine_z = {
          { "filetype", colored = false },
        },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {
          {
            "buffers",
            symbols = {
              modified = "",
              alternate_file = "",
              directory = "",
            },
            filetype_names = {
              ["neo-tree"] = "[file explorer]",
            },
          },
        },
        lualine_c = {},
        lualine_x = {
          function()
            return string.lower(tostring(os.date("%I:%M:%S %p")))
          end,
        },
        lualine_y = {},
        lualine_z = {
          function()
            return my_icons[math.floor(os.date("%M") / 5) + 1] .. " vim"
          end,
        },
      },
      extensions = { "lazy" },
    }
  end,
}
