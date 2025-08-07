-- use custom lualine
local conform = require("conform")
local icons = require("lazyvim.config").icons
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

vim.api.nvim_set_hl(0, "formatters_and_lsps_active", { fg = colors.green, bg = colors.status_section_b_bg })
vim.api.nvim_set_hl(0, "formatters_and_lsps_inactive", { fg = colors.status_bg, bg = colors.status_section_b_bg })
vim.api.nvim_set_hl(0, "formatters_and_lsps_loading", { fg = colors.orange, bg = colors.status_section_b_bg })
vim.api.nvim_set_hl(0, "formatters_and_lsps_error", { fg = colors.red, bg = colors.status_section_b_bg })

------------------------------------------------------------------------------
-- helper functions
------------------------------------------------------------------------------

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
    icon = "",
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

local formatters_and_lsps_long_format = false

local function formatters_and_lsps_component()
  local function get_formatters(bufnr)
    local ok, formatters, lsp_formatter = pcall(conform.list_formatters_to_run, bufnr)
    if ok then
      return formatters, lsp_formatter
    end
    return {}, false
  end

  local function get_lsps(bufnr)
    local o, c = {}, {}
    for _, lsp in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      (lsp.name == "copilot" and c or o)[#(lsp.name == "copilot" and c or o) + 1] = lsp
    end
    return o, c
  end

  local function extract_names(icon, tbl)
    return vim.tbl_map(function(x)
      return icon .. " " .. x.name
    end, tbl)
  end

  local function is_formatting_enabled()
    if vim.b.autoformat ~= nil then
      return vim.b.autoformat
    end
    return vim.g.autoformat
  end

  local function parse_formatters(formatters, lsp_formatter)
    local icon = "󱇨"
    if formatters_and_lsps_long_format then
      return extract_names(icon, formatters)
    end
    local status = "inactive"
    if is_formatting_enabled() and (#formatters > 0 or lsp_formatter) then
      status = "active"
    end
    return { hl("formatters_and_lsps_" .. status) .. icon }
  end

  local function parse_lsps(lsps)
    local icon = "󰱽"
    if formatters_and_lsps_long_format then
      return extract_names(icon, lsps)
    end
    local status = "inactive"
    if #lsps > 0 then
      status = "active"
    end
    return { hl("formatters_and_lsps_" .. status) .. icon }
  end

  local function parse_copilot(lsps)
    local icon = icons.kinds.Copilot
    if formatters_and_lsps_long_format then
      return extract_names(icon, lsps)
    end
    local status = "inactive"
    if #lsps > 0 then
      local ok, copilot_status_module = pcall(require, "copilot.status")
      if ok and copilot_status_module.data then
        if copilot_status_module.data.status == "Normal" then
          status = "active"
        elseif copilot_status_module.data.status == "InProgress" then
          status = "loading"
        else
          status = "error"
        end
      end
    end
    return { hl("formatters_and_lsps_" .. status) .. icon }
  end

  local function generate()
    local bufnr = vim.api.nvim_get_current_buf()
    local formatters, lsp_formatter = get_formatters(bufnr)
    local lsps, copilot = get_lsps(bufnr)
    local parsed = {}
    vim.list_extend(parsed, parse_formatters(formatters, lsp_formatter))
    vim.list_extend(parsed, parse_lsps(lsps))
    vim.list_extend(parsed, parse_copilot(copilot))
    return table.concat(parsed, formatters_and_lsps_long_format and section_b_separator(" | ") or " ")
  end

  return {
    generate,
    on_click = function()
      formatters_and_lsps_long_format = not formatters_and_lsps_long_format
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
