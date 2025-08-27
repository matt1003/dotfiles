local Component = require("lualine.component")
local Buffer = require("plugins.overrides.lualine.components.buffers.buffer")
local get_mode_suffix = require("lualine.highlight").get_mode_suffix

local default_options = {
  ellipsis = "...",
  max_length = function()
    return math.max(vim.o.columns - 10, 0)
  end,
  buffer = {
    -- :p = path (the full path)
    -- :t = tail (the file name with extension)
    -- :r = root (the file name without extension)
    -- :e = extension (file extension)
    format = ":t",
    separator = "",
    padding = " ",
    ellipsis = "…",
    max_name_length = 32,
  },
}

local function is_listed(bufnr)
  return vim.bo[bufnr].buflisted
end

local function is_last(current, last)
  return current == last
end

local function get_max_length(max_length)
  return type(max_length) == "function" and max_length() or max_length
end

local function get_start_end_indexes(buffers)
  return 1, #buffers
end

local function get_active_index(active_index, start_index, end_index)
  if not active_index or active_index < start_index then
    active_index = start_index
  elseif active_index > end_index then
    active_index = end_index
  end
  return active_index, math.max(active_index - start_index, end_index - active_index)
end

local function shift_towards_start(active_index, current_offset, start_index)
  return math.max(active_index - current_offset, start_index)
end

local function shift_towards_end(active_index, current_offset, end_index)
  return math.min(active_index + current_offset, end_index)
end

local function get_ellipsis(current_start_index, current_end_index, start_index, end_index, ellipsis)
  return {
    _start = current_start_index > start_index and ellipsis or nil,
    _end = current_end_index < end_index and ellipsis or nil,
  }
end

local function calculate_length(buffers, start_index, end_index, ellipsis)
  local length = buffers[end_index].prefixsum - buffers[start_index].prefixsum + buffers[start_index].length
  local length = buffers[end_index].prefixsum - ((buffers[start_index - 1] and buffers[start_index - 1].prefixsum) or 0)
  if ellipsis._start then
    length = length + ellipsis._start.length
  end
  if ellipsis._end then
    length = length + ellipsis._end.length
  end
  return length
end

local function slice(buffers, start_index, end_index, ellipsis)
  local sliced = {}
  local index = 1

  if ellipsis and ellipsis._start then
    sliced[index] = ellipsis._start
    index = index + 1
  end

  for i = start_index, end_index do
    sliced[index] = buffers[i]
    index = index + 1
  end

  if ellipsis and ellipsis._end then
    sliced[index] = ellipsis._end
    index = index + 1
  end

  return sliced
end

local Buffers = Component:extend()

function Buffers:init(options)
  Buffers.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
  self.active_index = nil
  self.total_length = 0
  self.ellipsis = Buffer:new(-1, 0, self.options.buffer, "", self.options.ellipsis)
end

function Buffers:get_buffers()
  local buffers = {}
  self.total_length = 0
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if is_listed(bufnr) then
      local buffer = Buffer:new(bufnr, self.total_length, self.options.buffer)
      table.insert(buffers, buffer)
      if buffer.is_active then
        self.active_index = #buffers
      end
      self.total_length = buffer.prefixsum
    end
  end
  return buffers
end

function Buffers:select_buffers(buffers)
  if #buffers == 0 then
    return {}
  end

  local max_length = get_max_length(self.options.max_length)

  if max_length <= 0 then
    return {}
  end

  local start_index, end_index = get_start_end_indexes(buffers)
  local active_index, max_offset = get_active_index(self.active_index, start_index, end_index)

  local current_offset = 0

  while current_offset <= max_offset do
    local current_start_index = shift_towards_start(active_index, current_offset, start_index)
    local current_end_index = shift_towards_end(active_index, current_offset, end_index)
    local ellipsis = get_ellipsis(current_start_index, current_end_index, start_index, end_index, self.ellipsis)
    local length = calculate_length(buffers, current_start_index, current_end_index, ellipsis)

    if length > max_length then
      if current_offset == 0 then
        return {}
      else
        -- Option 1: shrink start side only
        local previous_start_index = shift_towards_start(active_index, current_offset - 1, start_index)
        ellipsis = get_ellipsis(previous_start_index, current_end_index, start_index, end_index, self.ellipsis)
        length = calculate_length(buffers, previous_start_index, current_end_index, ellipsis)
        if length <= max_length then
          return slice(buffers, previous_start_index, current_end_index, ellipsis)
        end
        -- Option 2: shrink end side only
        local previous_end_index = shift_towards_end(active_index, current_offset - 1, end_index)
        ellipsis = get_ellipsis(current_start_index, previous_end_index, start_index, end_index, self.ellipsis)
        length = calculate_length(buffers, current_start_index, previous_end_index, ellipsis)
        if length <= max_length then
          return slice(buffers, current_start_index, previous_end_index, ellipsis)
        end
        -- Fallback: shrink both sides (last fully valid state)
        ellipsis = get_ellipsis(previous_start_index, previous_end_index, start_index, end_index, self.ellipsis)
        return slice(buffers, previous_start_index, previous_end_index, ellipsis)
      end
    end
    current_offset = current_offset + 1
  end

  -- Never exceeded max_length, therefore return full slice
  return slice(buffers, start_index, end_index)
end

function Buffers:render_buffers(buffers)
  local mode_suffix = get_mode_suffix()
  local rendered = ""
  for index, buffer in ipairs(buffers) do
    rendered = rendered .. buffer:render(mode_suffix, is_last(index, #buffers))
  end
  return rendered
end

function Buffers:update_status()
  return self:render_buffers(self:select_buffers(self:get_buffers()))
end

vim.cmd([[
  function! LualineSwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    execute ":buffer " . a:bufnr
  endfunction
  command! -nargs=1 -bang LualineBuffersJump call v:lua.require'lualine.components.buffers'.buffer_jump(<f-args>, "<bang>")
]])

return Buffers
