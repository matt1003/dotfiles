local function class(base)
  local c = {}
  if type(base) == "table" then
    for k, v in pairs(base) do
      c[k] = v
    end
    c._base = base
  end
  c.__index = c

  function c:new(...)
    local instance = setmetatable({}, c)
    if instance.init then
      instance:init(...)
    end
    return instance
  end

  function c:extend()
    return class(self)
  end

  return c
end

local function len(text)
  return vim.fn.strchars(text)
end

local function truncate_start(text, max_length, ellipsis)
  local ellipsis_length = len(ellipsis)
  return ellipsis .. vim.fn.strcharpart(text, len(text) - (max_length - ellipsis_length), max_length - ellipsis_length)
end

local function truncate_end(text, max_length, ellipsis)
  local ellipsis_length = len(ellipsis)
  return vim.fn.strcharpart(text, 0, max_length - ellipsis_length) .. ellipsis
end

local function truncate(text, max_length, ellipsis, start)
  if len(text) > max_length then
    if start then
      text = truncate_start(text, max_length, ellipsis)
    else
      text = truncate_end(text, max_length, ellipsis)
    end
  end
  return text
end

local function is_active(bufnr)
  return bufnr > 0 and bufnr == vim.api.nvim_get_current_buf()
end

local function is_modified(bufnr)
  return bufnr > 0 and vim.bo[bufnr].modified
end

local function get_fullname(bufnr)
  return bufnr > 0 and vim.api.nvim_buf_get_name(bufnr) or nil
end

local function get_name(fullname, format, max_name_length, ellipsis)
  local name = ""
  if fullname and fullname ~= "" then
    name = vim.fn.fnamemodify(fullname, format)
  end
  if not name or name == "" then
    name = "[No Name]"
  end
  return truncate(name, max_name_length, ellipsis, format == ":p")
end

local function get_icon(fullname)
  -- TODO:: Don't require nvim-web-devicons each time:
  --
  --local success, web_devicons = pcall(require, "nvim-web-devicons")
  --if success then
  --icon, _ = web_devicons.get_icon(name)
  --end
  --
  local devicons = require("nvim-web-devicons")
  local extension = vim.fn.fnamemodify(fullname, ":e")
  local icon, _ = devicons.get_icon(fullname, extension, { default = true })
  -- TODO:: Handle icons for directories:
  return icon and icon .. " " or ""
end

local function calculate_length(separator_len, padding_len, icon_len, name_len)
  return separator_len + padding_len + icon_len + name_len + padding_len + separator_len
end

local function calculate_prefixsum(total_length, length)
  return total_length + length
end

local function get_highlight(hl_group, active, modified, separator_suffix, mode_suffix)
  if active then
    hl_group = hl_group .. "_active"
  else
    hl_group = hl_group .. "_inactive"
  end
  if modified then
    hl_group = hl_group .. "_modified"
  end
  if separator_suffix then
    hl_group = hl_group .. separator_suffix
  end
  if mode_suffix then
    hl_group = hl_group .. mode_suffix
  end
  return "%#" .. hl_group .. "#"
end

local Buffer = class()

function Buffer:init(bufnr, total_length, opts, override_icon, override_name)
  self.bufnr = bufnr
  self.opts = opts
  self.is_active = is_active(bufnr)
  self.is_modified = is_modified(bufnr)
  self.fullname = get_fullname(bufnr)
  self.name = override_name or get_name(self.fullname, self.opts.format, self.opts.max_name_length, self.opts.ellipsis)
  self.icon = override_icon or get_icon(self.fullname)
  self.length = calculate_length(len(self.opts.separator), len(self.opts.padding), len(self.icon), len(self.name))
  self.prefixsum = calculate_prefixsum(total_length, self.length)
end

function Buffer:configure_mouse_click(text)
  return self.bufnr > 0 and string.format("%%%s@LualineSwitchBuffer@%s%%T", self.bufnr, text) or text
end

function Buffer:highlight(mode_suffix, separator_suffix)
  return get_highlight("lualine_buffers", self.is_active, self.is_modified, separator_suffix, mode_suffix)
end

function Buffer:render(mode_suffix, is_last)
  local rendered = self:highlight(mode_suffix, "_separator")
    .. self.opts.separator
    .. self:highlight(mode_suffix)
    .. self:configure_mouse_click(self.opts.padding .. self.icon .. self.name .. self.opts.padding)
    .. self:highlight(mode_suffix, "_separator_reversed")
  if not is_last then
    rendered = rendered .. self.opts.separator
  end
  return rendered
end

function Buffer:__tostring()
  return string.format("Buffer[%d]: %s", self.bufnr, self.name)
end

return Buffer
