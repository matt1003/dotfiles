-- use custom lualine
local Util = require("lazyvim.util")

------------------------------------------------------------------------------
-- color scheme
------------------------------------------------------------------------------

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
  gray1 = os.getenv("FG2"), -- light
  gray2 = os.getenv("FG4"), -- medium
  gray3 = os.getenv("BG4"), -- dark
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

vim.api.nvim_set_hl(0, "lualine_a_separator", { fg = colors.gray1, bg = colors.status_section_a_bg })
vim.api.nvim_set_hl(0, "lualine_b_separator", { fg = colors.gray2, bg = colors.status_section_b_bg })
vim.api.nvim_set_hl(0, "lualine_c_separator", { fg = colors.gray3, bg = colors.status_section_c_bg })

------------------------------------------------------------------------------
-- helper functions
------------------------------------------------------------------------------

local function merge(t1, t2)
  local result = {}

  for _, v in pairs(t1) do
    table.insert(result, v)
  end

  for _, v in pairs(t2) do
    table.insert(result, v)
  end

  return result
end

local function hl(color)
  return "%#" .. color .. "#"
end

local function section_b_separator(separator)
  return hl("lualine_b_separator") .. separator .. hl("lualine_b_normal")
end

local function section_c_separator(separator)
  return hl("lualine_c_separator") .. separator .. hl("lualine_c_normal")
end

------------------------------------------------------------------------------
-- mode component
------------------------------------------------------------------------------

local function mode_component()
  return {
    "mode",
    separator = { left = "", right = "" },
  }
end

------------------------------------------------------------------------------
-- rood directory component
------------------------------------------------------------------------------

local function root_directory_component()
  local config = Util.lualine.root_dir({ color = {}, icon = "󱉭" })
  config.separator = section_b_separator("")
  return config
end

------------------------------------------------------------------------------
-- current branch component
------------------------------------------------------------------------------

local function current_branch_component()
  return {
    "branch",
  }
end

------------------------------------------------------------------------------
-- current file component
------------------------------------------------------------------------------

local function current_file_component()
  return {
    Util.lualine.pretty_path({ relative = "root", modified_hl = "GruvboxOrangeBold" }),
    separator = section_c_separator(""),
  }
end

------------------------------------------------------------------------------
-- diff component
------------------------------------------------------------------------------

local function diff_component()
  local icons = require("lazyvim.config").icons
  return {
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
    separator = section_c_separator(""),
  }
end

------------------------------------------------------------------------------
-- diagnostics component
------------------------------------------------------------------------------

local function diagnostics_component()
  local icons = require("lazyvim.config").icons
  return {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    separator = section_c_separator(""),
  }
end

------------------------------------------------------------------------------
-- location component
------------------------------------------------------------------------------

local function location_component()
  local function search_count()
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
    return string.format("%d/%d ", result.current, denominator)
  end

  local function line_number()
    return vim.fn.line(".") .. ""
  end

  local function column_number()
    return vim.fn.charcol(".") .. ""
  end

  local function file_percentage()
    return math.floor(vim.fn.line(".") / vim.fn.line("$") * 100) .. "%%"
  end

  local function generate()
    return table.concat({ search_count(), line_number(), column_number(), file_percentage() }, " ")
  end

  return {
    function()
      return generate()
    end,
  }
end

------------------------------------------------------------------------------
-- formatters and lsps component
------------------------------------------------------------------------------

local show_formatters_and_lsps_component = false

local function formatters_and_lsps_component()
  local function get_formatters()
    return vim.tbl_map(function(formatter)
      return "󱇨 " .. formatter.name
    end, require("conform").list_formatters_to_run(vim.api.nvim_get_current_buf()))
  end

  local function get_lsps()
    return vim.tbl_map(function(client)
      return "󰱽 " .. client.name
    end, vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
  end

  local function generate()
    return table.concat(merge(get_formatters(), get_lsps()), section_b_separator(" | "))
  end

  return {
    function()
      return generate()
    end,
    cond = function()
      return show_formatters_and_lsps_component
    end,
  }
end

------------------------------------------------------------------------------
-- file type component
------------------------------------------------------------------------------

local filetype_substitutions = {
  { "typescript", "ts" },
  { "javascript", "js" },
  { "python", "py" },
}

local function filetype_component()
  return {
    "filetype",
    colored = false,
    separator = { left = "", right = "" },
    on_click = function()
      show_formatters_and_lsps_component = not show_formatters_and_lsps_component
    end,
    fmt = function(str)
      for _, sub in ipairs(filetype_substitutions) do
        str = str:gsub(sub[1], sub[2])
      end
      return str
    end,
  }
end

------------------------------------------------------------------------------
-- buffers component
------------------------------------------------------------------------------

local function buffers_component()
  return {
    "buffers",
    max_length = function()
      return vim.o.columns - 10
    end,
    symbols = {
      modified = "",
      alternate_file = "",
      directory = "",
    },
    filetype_names = {
      ["lazy"] = "[Lazy]",
    },
    buffers_color = {
      active = { fg = colors.status_section_a_fg, bg = colors.status_section_a_bg, gui = "bold" },
      active_modified = { fg = colors.status_section_a_fg, bg = colors.orange, gui = "bold" },
      active_separator = { fg = colors.status_bg, bg = colors.status_section_a_bg },
      active_modified_separator = { fg = colors.status_bg, bg = colors.orange },
      inactive = { fg = colors.gray1, bg = colors.status_section_b_bg },
      inactive_modified = { fg = colors.orange, bg = colors.status_section_b_bg },
      inactive_separator = { fg = colors.status_bg, bg = colors.status_section_b_bg },
      inactive_modified_separator = { fg = colors.status_bg, bg = colors.status_section_b_bg },
    },
  }
end

------------------------------------------------------------------------------
-- vibes component
------------------------------------------------------------------------------

local vibes_format = "@icon@ nvim"

local vibes_icons = { "", "", "", "󱙝", "", "", "󰣙", "󰻖", "", "󰼂", "󰑮", "󱙴" }

local function select_vibes_icon()
  return vibes_icons[math.floor(os.date("%M") / #vibes_icons) + 1]
end

local function vibes_component()
  local function generate()
    return string.gsub(vibes_format, "@icon@", select_vibes_icon())
  end

  return {
    function()
      return generate()
    end,
    on_click = function()
      vim.fn.system("wallpaper")
    end,
    separator = { left = "", right = "" },
  }
end

------------------------------------------------------------------------------
-- lualine configuration
------------------------------------------------------------------------------

return {
  "matt1003/lualine.nvim",
  lazy = false,
  config = function()
    --vim.o.laststatus = vim.g.lualine_laststatus
    require("lualine").setup({
      options = {
        theme = gruvbox,
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          mode_component(),
        },
        lualine_b = {
          root_directory_component(),
          current_branch_component(),
        },
        lualine_c = {
          current_file_component(),
          diff_component(),
          diagnostics_component(),
        },
        lualine_x = {
          location_component(),
        },
        lualine_y = {
          formatters_and_lsps_component(),
        },
        lualine_z = {
          filetype_component(),
        },
      },
      tabline = {
        lualine_a = {},
        lualine_b = {
          buffers_component(),
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          vibes_component(),
        },
      },
      extensions = { "lazy" },
    })
  end,
}
