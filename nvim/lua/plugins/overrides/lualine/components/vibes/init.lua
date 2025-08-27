local Component = require("lualine.component")

local default_options = {
  format = "@icon@ nvim",
  icons = { "", "", "", "󱙝", "", "", "󰣙", "󰻖", "", "󰼂", "󰑮", "󱙴" },
}

local Vibes = Component:extend()

function Vibes:init(options)
  Vibes.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function Vibes:select_vibes_icon()
  return self.options.icons[math.floor(os.date("%M") / #self.options.icons) + 1]
end

function Vibes:update_status()
  return string.gsub(self.options.format, "@icon@", self:select_vibes_icon())
end

return Vibes
