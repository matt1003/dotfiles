local Component = require("lualine.component")

local default_options = {
  spacing = " ",
  icons = {
    search = " ",
    line_number = "",
    column_number = "",
    file_percentage = "%%",
  },
}

local Location = Component:extend()

function Location:init(options)
  Location.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function Location:search_count()
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
  return string.format("%d/%d%s", result.current, denominator, self.options.icons.search)
end

function Location:line_number()
  return vim.fn.line(".") .. self.options.icons.line_number
end

function Location:column_number()
  return vim.fn.charcol(".") .. self.options.icons.column_number
end

function Location:file_percentage()
  return math.floor(vim.fn.line(".") / vim.fn.line("$") * 100) .. self.options.icons.file_percentage
end

function Location:get_all()
  return { self:search_count(), self:line_number(), self:column_number(), self:file_percentage() }
end

function Location:update_status()
  return table.concat(self:get_all(), self.options.spacing)
end

return Location
