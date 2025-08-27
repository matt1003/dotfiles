local Component = require("lualine.component")
local conform = require("conform")

local get_mode_suffix = require("lualine.highlight").get_mode_suffix

local default_options = {
  default_format = "short",
  separators = {
    short = " ",
    long = " | ",
  },
  icons = {
    formatters = "󱇨",
    lsps = "󰱽",
    copilot = require("lazyvim.config").icons.kinds.Copilot,
  },
}

local function hl(color)
  return "%#" .. color .. get_mode_suffix() .. "#"
end

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

local Assistants = Component:extend()

Assistants.format = nil

function Assistants:init(options)
  Assistants.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
  Assistants.format = self.options.default_format
end

function Assistants:parse_formatters(formatters, lsp_formatter)
  if Assistants.format == "long" then
    return extract_names(self.options.icons.formatters, formatters)
  end
  local status = "inactive"
  if is_formatting_enabled() and (#formatters > 0 or lsp_formatter) then
    status = "active"
  end
  return { hl("formatters_and_lsps_" .. status) .. self.options.icons.formatters }
end

function Assistants:parse_lsps(lsps)
  if Assistants.format == "long" then
    return extract_names(self.options.icons.lsps, lsps)
  end
  local status = "inactive"
  if #lsps > 0 then
    status = "active"
  end
  return { hl("formatters_and_lsps_" .. status) .. self.options.icons.lsps }
end

function Assistants:parse_copilot(lsps)
  if Assistants.format == "long" then
    return extract_names(self.options.icons.copilot, lsps)
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
  return { hl("formatters_and_lsps_" .. status) .. self.options.icons.copilot }
end

function Assistants:generate() end

function Assistants:update_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local formatters, lsp_formatter = get_formatters(bufnr)
  local lsps, copilot = get_lsps(bufnr)
  local parsed = {}
  vim.list_extend(parsed, self:parse_formatters(formatters, lsp_formatter))
  vim.list_extend(parsed, self:parse_lsps(lsps))
  vim.list_extend(parsed, self:parse_copilot(copilot))
  if #parsed == 0 then
    table.insert(parsed, "(none)")
  end
  return table.concat(parsed, self.options.separators[Assistants.format])
end

function Assistants:toggle_format()
  Assistants.format = Assistants.format == "long" and "short" or "long"
end

return Assistants
