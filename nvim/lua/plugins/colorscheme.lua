-- configure colorscheme
--
local function map(tbl, fun, ctx)
  local res = {}
  for key, val in pairs(tbl) do
    res[key] = fun(key, val, ctx)
  end
  return res
end

local color_map = {
  -- modes
  Normal = "FG",
  Insert = "GREEN",
  Visual = "YELLOW",
  Replace = "RED",
  Command = "BLUE",
  Terminal = "AQUA",
  -- diagnostics
  Error = "RED",
  Warn = "YELLOW",
  Info = "BLUE",
  Hint = "AQUA",
}

local function get_env_color(name)
  return os.getenv(name)
end

local function get_blended_color(color, level)
  return get_env_color((color_map[color] or color) .. "_" .. level)
end

local function is_blended_color(attribute_value)
  return type(attribute_value) == "table" and attribute_value.color and attribute_value.level
end

local function hl_name(hl_prefix, hl_suffix, neotree_level)
  return hl_prefix .. (neotree_level and "_" .. neotree_level or "") .. hl_suffix
end

local function convert_blended_color(_, attribute_value)
  return is_blended_color(attribute_value) and get_blended_color(attribute_value.color, attribute_value.level)
    or attribute_value
end

local function apply_neotree_fades(attribute_name, attribute_value, override_level)
  return (attribute_name == "fg" and is_blended_color(attribute_value))
      and { color = attribute_value.color, level = override_level }
    or attribute_value
end

local overrides = {}

local function add_highlight_override(hl_prefix, hl_suffix, hl_attributes, neotree_level)
  overrides[hl_name(hl_prefix, hl_suffix, neotree_level)] = map(hl_attributes, convert_blended_color)
end

local function generate_highlight_overrides(hl_prefix, hl_table, neotree_fades_table)
  for hl_suffix, hl_attributes in pairs(hl_table) do
    add_highlight_override(hl_prefix, hl_suffix, hl_attributes)
    for neotree_level, override_level in pairs(neotree_fades_table or {}) do
      local hl_attributes_faded = map(hl_attributes, apply_neotree_fades, override_level)
      add_highlight_override(hl_prefix, hl_suffix, hl_attributes_faded, neotree_level)
    end
  end
end

local function blended(color, level)
  return { color = color, level = level }
end

local function neotree_fades(level1, level2, level3)
  return { [68] = level1, [60] = level2, [35] = level3 }
end

-- ### Mode Based Highlights

generate_highlight_overrides("LineNr", {
  Normal = { fg = blended("Normal", 40) },
  Insert = { fg = blended("Insert", 40) },
  Visual = { fg = blended("Visual", 40) },
  Replace = { fg = blended("Replace", 40) },
  Command = { fg = blended("Command", 40) },
  Terminal = { fg = blended("Terminal", 40) },
})

generate_highlight_overrides("CursorLineNr", {
  Normal = { fg = blended("Normal", 100) },
  Insert = { fg = blended("Insert", 100) },
  Visual = { fg = blended("Visual", 100) },
  Replace = { fg = blended("Replace", 100) },
  Command = { fg = blended("Command", 100) },
  Terminal = { fg = blended("Terminal", 100) },
})

generate_highlight_overrides("CursorLine", {
  Normal = { bg = blended("Normal", 5) },
  Insert = { bg = blended("Insert", 10) },
  Visual = { bg = blended("Visual", 10) },
  Replace = { bg = blended("Replace", 10) },
  Command = { bg = blended("Command", 10) },
  Terminal = { bg = blended("Terminal", 10) },
})

generate_highlight_overrides("NeoTreeCursorLine", {
  Normal = { bg = blended("Normal", 5) },
  Insert = { bg = blended("Insert", 10) },
  Visual = { bg = blended("Visual", 10) },
  Replace = { bg = blended("Replace", 10) },
  Command = { bg = blended("Command", 10) },
  Terminal = { bg = blended("Terminal", 10) },
})

generate_highlight_overrides("NeoTreeDimText", {
  Normal = { fg = blended("Normal", 20) },
  Insert = { fg = blended("Insert", 20) },
  Visual = { fg = blended("Visual", 20) },
  Replace = { fg = blended("Replace", 20) },
  Command = { fg = blended("Command", 20) },
  Terminal = { fg = blended("Terminal", 20) },
})

generate_highlight_overrides("NeoTreeDirectoryName", {
  Normal = { fg = blended("BLUE", 80) },
  Insert = { fg = blended("Insert", 80) },
  Visual = { fg = blended("Visual", 80) },
  Replace = { fg = blended("Replace", 80) },
  Command = { fg = blended("Command", 80) },
  Terminal = { fg = blended("Terminal", 80) },
}, neotree_fades(50, 30, 10))

generate_highlight_overrides("NeoTreeDotfile", {
  Normal = { fg = blended("Normal", 50) },
  Insert = { fg = blended("Insert", 30) },
  Visual = { fg = blended("Visual", 30) },
  Replace = { fg = blended("Replace", 30) },
  Command = { fg = blended("Command", 30) },
  Terminal = { fg = blended("Terminal", 30) },
}, neotree_fades(15, 10, 5))

generate_highlight_overrides("NeoTreeFileName", {
  Normal = { fg = blended("Normal", 60) },
  Insert = { fg = blended("Insert", 50) },
  Visual = { fg = blended("Visual", 50) },
  Replace = { fg = blended("Replace", 50) },
  Command = { fg = blended("Command", 50) },
  Terminal = { fg = blended("Terminal", 50) },
}, neotree_fades(25, 15, 5))

generate_highlight_overrides("NeoTreeFileNameOpened", {
  Normal = { fg = blended("Normal", 100) },
  Insert = { fg = blended("Insert", 100) },
  Visual = { fg = blended("Visual", 100) },
  Replace = { fg = blended("Replace", 100) },
  Command = { fg = blended("Command", 100) },
  Terminal = { fg = blended("Terminal", 100) },
}, neotree_fades(50, 30, 10))

generate_highlight_overrides("NeoTreeModified", {
  Normal = { fg = blended("ORANGE", 100), italic = true },
  Insert = { fg = blended("ORANGE", 100), italic = true },
  Visual = { fg = blended("ORANGE", 100), italic = true },
  Replace = { fg = blended("ORANGE", 100), italic = true },
  Command = { fg = blended("ORANGE", 100), italic = true },
  Terminal = { fg = blended("ORANGE", 100), italic = true },
}, neotree_fades(50, 30, 10))

generate_highlight_overrides("NeoTreeRootName", {
  Normal = { fg = blended("BLUE", 80), italic = true },
  Insert = { fg = blended("Insert", 80), italic = true },
  Visual = { fg = blended("Visual", 80), italic = true },
  Replace = { fg = blended("Replace", 80), italic = true },
  Command = { fg = blended("Command", 80), italic = true },
  Terminal = { fg = blended("Terminal", 80), italic = true },
}, neotree_fades(50, 30, 10))

generate_highlight_overrides("WinSeparator", {
  Normal = { fg = blended("Normal", 30) },
  Insert = { fg = blended("Insert", 50) },
  Visual = { fg = blended("Visual", 50) },
  Replace = { fg = blended("Replace", 50) },
  Command = { fg = blended("Command", 50) },
  Terminal = { fg = blended("Terminal", 50) },
})

-- ### Diagnostic Highlights

generate_highlight_overrides("DiagnosticFloating", {
  Error = { fg = blended("Error", 100) },
  Warn = { fg = blended("Warn", 100) },
  Info = { fg = blended("Info", 100) },
  Hint = { fg = blended("Hint", 100) },
})

generate_highlight_overrides("DiagnosticVirtualText", {
  Error = { fg = blended("Error", 30) },
  Warn = { fg = blended("Warn", 30) },
  Info = { fg = blended("Info", 30) },
  Hint = { fg = blended("Hint", 30) },
})

generate_highlight_overrides("DiagnosticUnderline", {
  Error = { undercurl = true, sp = blended("Error", 30) },
  Warn = { undercurl = true, sp = blended("Warn", 30) },
  Info = { undercurl = true, sp = blended("Info", 30) },
  Hint = { undercurl = true, sp = blended("Hint", 30) },
})

-- ### Miscellaneous Highlights

generate_highlight_overrides("", {
  MatchParen = { link = "GruvboxYellowBold" },
  Pmenu = { bg = "" },
  SpellBad = { link = "GruvboxPurpleUnderline" },
  SpellCap = { link = "GruvboxPurpleUnderline" },
  Visual = { fg = blended("FG", 0), bg = blended("YELLOW", 100) },
})

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = true,
      overrides = overrides,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "gruvbox"
    end,
  },
}
