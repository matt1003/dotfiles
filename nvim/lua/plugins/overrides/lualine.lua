-- use custom lualine
local Util = require("lazyvim.util")
local my_icons = { "", "", "", "󱙝", "", "", "󰣙", "󰻖", "", "󰼂", "󰑮", "󱙴" }

local colors = {
  status_fg = os.getenv("STATUS_FG"),
  status_bg = os.getenv("STATUS_BG"),
  status_section_a_fg = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg = os.getenv("STATUS_SECTION_A_BG"),
  status_section_b_fg = os.getenv("STATUS_SECTION_B_FG"),
  status_section_b_bg = os.getenv("STATUS_SECTION_B_BG"),
  status_section_c_fg = os.getenv("STATUS_SECTION_C_FG"),
  status_section_c_bg = os.getenv("STATUS_SECTION_C_BG"),
  red = os.getenv("RED"),
  green = os.getenv("GREEN"),
  yellow = os.getenv("YELLOW"),
  blue = os.getenv("BLUE"),
  purple = os.getenv("PURPLE"),
  aqua = os.getenv("AQUA"),
  orange = os.getenv("ORANGE"),
  gray = os.getenv("F4"),
}

local gruvbox = {
  normal = {
    a = { fg = colors.status_section_a_fg, bg = colors.status_section_a_bg, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  insert = {
    a = { fg = colors.status_section_a_fg, bg = colors.green, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  visual = {
    a = { fg = colors.status_section_a_fg, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  replace = {
    a = { fg = colors.status_section_a_fg, bg = colors.red, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  command = {
    a = { fg = colors.status_section_a_fg, bg = colors.purple, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  terminal = {
    a = { fg = colors.status_section_a_fg, bg = colors.aqua, gui = "bold" },
    b = { fg = colors.status_section_b_fg, bg = colors.status_section_b_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
  inactive = {
    a = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg, gui = "bold" },
    b = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
    c = { fg = colors.status_section_c_fg, bg = colors.status_section_c_bg },
  },
}

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
        theme = gruvbox,
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        -- (A b c ... x y z): Mode
        lualine_a = { "mode" },
        -- (a B c ... x y z): Current Directory | Current Branch
        lualine_b = {
          Util.lualine.root_dir({ color = {}, icon = "󱉭" }),
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
            if denominator == 0 then
              return ""
            end
            return string.format(" %d/%d", result.current, denominator)
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
            max_length = vim.o.columns - 10,
            --buffers_color = {
            --active = 'lualine_{section}_normal',
            --inactive = 'lualine_{section}_inactive',
            --},
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
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          function()
            return my_icons[math.floor(os.date("%M") / 5) + 1] .. " nvim"
          end,
        },
      },
      extensions = { "lazy" },
    }
  end,
}
