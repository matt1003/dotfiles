-- use custom lualine
local icons = require("lazyvim.config").icons
local util = require("lazyvim.util")

local Assistants = require("plugins.overrides.lualine.components.assistants")
local Buffers = require("plugins.overrides.lualine.components.buffers")
local Location = require("plugins.overrides.lualine.components.location")
local Vibes = require("plugins.overrides.lualine.components.vibes")

------------------------------------------------------------------------------
-- color scheme
------------------------------------------------------------------------------

local colors = {
  status_fg = os.getenv("STATUS_FG"),
  status_bg = os.getenv("STATUS_BG"),

  status_section_a_fg_normal = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_normal = os.getenv("STATUS_SECTION_A_BG"),
  status_section_b_fg_normal = os.getenv("STATUS_SECTION_B_FG"),
  status_section_b_bg_normal = os.getenv("STATUS_SECTION_B_BG"),
  status_section_c_fg_normal = os.getenv("STATUS_SECTION_C_FG"),
  status_section_c_bg_normal = os.getenv("STATUS_SECTION_C_BG"),

  status_section_a_fg_insert = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_insert = os.getenv("GREEN_100"),
  status_section_b_fg_insert = os.getenv("GREEN_100"),
  status_section_b_bg_insert = os.getenv("GREEN_35"),
  status_section_c_fg_insert = os.getenv("GREEN_85"),
  status_section_c_bg_insert = os.getenv("GREEN_15"),

  status_section_a_fg_visual = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_visual = os.getenv("YELLOW_100"),
  status_section_b_fg_visual = os.getenv("YELLOW_100"),
  status_section_b_bg_visual = os.getenv("YELLOW_35"),
  status_section_c_fg_visual = os.getenv("YELLOW_85"),
  status_section_c_bg_visual = os.getenv("YELLOW_15"),

  status_section_a_fg_replace = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_replace = os.getenv("RED_100"),
  status_section_b_fg_replace = os.getenv("RED_100"),
  status_section_b_bg_replace = os.getenv("RED_35"),
  status_section_c_fg_replace = os.getenv("RED_85"),
  status_section_c_bg_replace = os.getenv("RED_15"),

  status_section_a_fg_command = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_command = os.getenv("BLUE_100"),
  status_section_b_fg_command = os.getenv("BLUE_100"),
  status_section_b_bg_command = os.getenv("BLUE_35"),
  status_section_c_fg_command = os.getenv("BLUE_85"),
  status_section_c_bg_command = os.getenv("BLUE_15"),

  status_section_a_fg_terminal = os.getenv("STATUS_SECTION_A_FG"),
  status_section_a_bg_terminal = os.getenv("AQUA_100"),
  status_section_b_fg_terminal = os.getenv("AQUA_100"),
  status_section_b_bg_terminal = os.getenv("AQUA_35"),
  status_section_c_fg_terminal = os.getenv("AQUA_85"),
  status_section_c_bg_terminal = os.getenv("AQUA_15"),

  status_section_a_fg_inactive = os.getenv("STATUS_SECTION_C_FG"),
  status_section_a_bg_inactive = os.getenv("STATUS_SECTION_C_BG"),
  status_section_b_fg_inactive = os.getenv("STATUS_SECTION_C_FG"),
  status_section_b_bg_inactive = os.getenv("STATUS_SECTION_C_BG"),
  status_section_c_fg_inactive = os.getenv("STATUS_SECTION_C_FG"),
  status_section_c_bg_inactive = os.getenv("STATUS_SECTION_C_BG"),

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

local gruvbox = {}
for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }) do
  gruvbox[mode] = {}
  for _, section in ipairs({ "a", "b", "c" }) do
    gruvbox[mode][section] = {
      fg = colors[string.format("status_section_%s_fg_%s", section, mode)],
      bg = colors[string.format("status_section_%s_bg_%s", section, mode)],
    }
    if section == "a" then
      gruvbox[mode][section].gui = "bold"
    end
  end
end

local function create_mode_highlights(tbl, section_key)
  for mode, sections in pairs(gruvbox) do
    for hl_name, hl_definition in pairs(tbl) do
      local combined = vim.tbl_extend("force", sections[section_key], hl_definition)
      if combined.gui == "bold" then
        combined.bold = true
        combined.gui = nil
      end
      vim.api.nvim_set_hl(0, string.format("%s_%s", hl_name, mode), combined)
    end
  end
end

create_mode_highlights({
  formatters_and_lsps_active = { fg = colors.green },
  formatters_and_lsps_inactive = { fg = colors.status_bg },
  formatters_and_lsps_loading = { fg = colors.orange },
  formatters_and_lsps_error = { fg = colors.status_bg },
}, "b")

create_mode_highlights({
  lualine_buffers_active = {},
  lualine_buffers_active_separator = { fg = colors.status_bg },
  lualine_buffers_active_separator_reversed = { fg = colors.status_bg, reverse = true },
  lualine_buffers_active_modified = { bg = colors.orange },
  lualine_buffers_active_modified_separator = { fg = colors.status_bg, bg = colors.orange },
  lualine_buffers_active_modified_separator_reversed = { fg = colors.status_bg, bg = colors.orange, reverse = true },
}, "a")

create_mode_highlights({
  lualine_buffers_inactive = {},
  lualine_buffers_inactive_separator = { fg = colors.status_bg },
  lualine_buffers_inactive_separator_reversed = { fg = colors.status_bg, reverse = true },
  lualine_buffers_inactive_modified = { fg = colors.orange },
  lualine_buffers_inactive_modified_separator = { fg = colors.status_bg },
  lualine_buffers_inactive_modified_separator_reversed = { fg = colors.status_bg, reverse = true },
}, "b")

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
  return util.lualine.root_dir({ color = {}, icon = "󱉭" })
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
    util.lualine.pretty_path({ relative = "root", modified_hl = "GruvboxOrangeBold" }),
    separator = "",
  }
end

------------------------------------------------------------------------------
-- diff component
------------------------------------------------------------------------------

local function diff_component()
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
    separator = "",
  }
end

------------------------------------------------------------------------------
-- diagnostics component
------------------------------------------------------------------------------

local function diagnostics_component()
  return {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    separator = "",
  }
end

------------------------------------------------------------------------------
-- location component
------------------------------------------------------------------------------

local function location_component()
  return {
    Location,
  }
end

------------------------------------------------------------------------------
-- assistants component
------------------------------------------------------------------------------

local function assistants_component()
  return {
    Assistants,
    on_click = function()
      Assistants:toggle_format()
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
    Buffers,
    padding = 0,
    separator = "",
  }
end

------------------------------------------------------------------------------
-- vibes component
------------------------------------------------------------------------------

local function vibes_component()
  return {
    Vibes,
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
  "nvim-lualine/lualine.nvim",
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
          assistants_component(),
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
