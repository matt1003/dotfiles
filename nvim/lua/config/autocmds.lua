local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Disable spelling:
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("DisableSpelling"),
  pattern = "*",
  command = "if &bt != '' | setlocal nospell | endif",
})

-- Enable cursor line in the active window only:
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "FocusGained" }, {
  group = augroup("EnableCursorLine"),
  pattern = "*",
  command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  group = augroup("DisableCursorLine"),
  pattern = "*",
  command = "if &ft != 'neo-tree' | setlocal nocursorline | endif",
})

-- Enable diagnostics pop-up:
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = {
        "BufLeave", -- Leave the buffer (e.g., :bn, :bp, :e <file>).
        "CursorMoved", -- Move cursor (prevents lingering float as you move).
        "InsertEnter", -- Enter insert mode (usually don't want float in your way).
        "FocusLost", -- Switch to another window or app.
        "WinLeave", -- Leave the current window (e.g., split navigation).
      },
    })
  end,
  desc = "Show diagnostic popup on hover",
})

local mode_to_hl_suffix_map = {
  -- Normal modes
  n = "Normal", -- Normal mode
  no = "Normal", -- Operator-pending (normal)
  nov = "Normal", -- Operator-pending (visual charwise)
  noV = "Normal", -- Operator-pending (visual linewise)
  ["no\22"] = "Normal", -- Operator-pending (visual blockwise)
  niI = "Normal", -- Normal, insert pending
  niR = "Normal", -- Normal, replace pending
  niV = "Normal", -- Normal, virtual replace pending
  nt = "Normal", -- Terminal Normal mode (terminal in normal mode)
  ntT = "Normal", -- Terminal job mode (terminal running job)
  -- Insert modes
  i = "Insert", -- Insert mode
  ic = "Insert", -- Insert mode, completion
  ix = "Insert", -- Insert mode, Ctrl-X completion
  -- Visual modes
  v = "Visual", -- Visual (charwise)
  vs = "Visual", -- Visual (charwise) with Select mode active
  V = "Visual", -- Visual (linewise)
  Vs = "Visual", -- Visual (linewise) with Select mode active
  ["\22"] = "Visual", -- Visual (blockwise, Ctrl-V)
  ["\22s"] = "Visual", -- Visual (blockwise) with Select mode active
  -- Select modes (typed text replaces selection)
  s = "Visual", -- Select (charwise)
  S = "Visual", -- Select (linewise)
  ["\19"] = "Visual", -- Select (blockwise)
  -- Replace modes
  R = "Replace", -- Replace mode
  Rc = "Replace", -- Replace mode, completion
  Rx = "Replace", -- Replace mode, Ctrl-X completion
  Rv = "Replace", -- Virtual Replace mode
  Rvc = "Replace", -- Virtual Replace mode, completion
  Rvx = "Replace", -- Virtual Replace mode, Ctrl-X completion
  r = "Replace", -- Hit-enter prompt (also REPLACE in lualine)
  -- Command-line modes
  c = "Command", -- Command-line mode (: commands)
  cv = "Command", -- Vim Ex mode (command-line window)
  ce = "Command", -- Normal Ex mode (command-line window)
  cr = "Command", -- Command-line from register
  cm = "Command", -- More prompt in command-line window
  cs = "Command", -- Select mode in command-line window
  -- Prompt modes (mapped to Command highlight)
  rm = "Command", -- More prompt (hit-enter prompt with --more--)
  ["r?"] = "Command", -- Confirm prompt (hit-enter prompt with confirmation)
  -- Terminal modes
  t = "Terminal", -- Terminal job mode (terminal is focused)
  -- Shell or external command mode
  ["!"] = "Normal", -- Shell or external command mode
}

local hl_to_be_mapped = {
  "LineNr",
  "CursorLine",
  "CursorLineNr",
  "NeoTreeCursorLine",
  "NeoTreeDimText",
  "NeoTreeDirectoryName",
  "NeoTreeDirectoryName_68",
  "NeoTreeDirectoryName_60",
  "NeoTreeDirectoryName_35",
  "NeoTreeDotfile",
  "NeoTreeDotfile_68",
  "NeoTreeDotfile_60",
  "NeoTreeDotfile_35",
  "NeoTreeFileName",
  "NeoTreeFileName_68",
  "NeoTreeFileName_60",
  "NeoTreeFileName_35",
  "NeoTreeFileNameOpened",
  "NeoTreeFileNameOpened_68",
  "NeoTreeFileNameOpened_60",
  "NeoTreeFileNameOpened_35",
  "NeoTreeModified",
  "NeoTreeModified_68",
  "NeoTreeModified_60",
  "NeoTreeModified_35",
  "NeoTreeRootName",
  "NeoTreeRootName_68",
  "NeoTreeRootName_60",
  "NeoTreeRootName_35",
  "WinSeparator",
}

local function check_mode_hl()
  for _, hl in ipairs(hl_to_be_mapped) do
    for _, suffix in pairs(mode_to_hl_suffix_map) do
      if vim.fn.hlexists(hl .. suffix) ~= 1 then
        vim.notify("Highlight group not found: " .. hl .. suffix, vim.log.levels.WARN)
      end
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("ModeColorChecker"),
  callback = function()
    check_mode_hl()
  end,
})

local last_mode = nil

local function apply_mode_hl()
  local mode = vim.fn.mode()
  if mode ~= last_mode then
    for _, hl in ipairs(hl_to_be_mapped) do
      vim.api.nvim_set_hl(0, hl, { link = hl .. (mode_to_hl_suffix_map[mode] or "Normal") })
    end
    vim.cmd("redraw")
    last_mode = mode
  end
end

local debounce_timer = vim.uv.new_timer()

local function apply_mode_hl_debounced()
  assert(debounce_timer, "debounce_timer is nil")
  debounce_timer:stop()
  debounce_timer:start(50, 0, function()
    vim.schedule(apply_mode_hl)
  end)
end

vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "WinEnter", "FocusGained", "ColorScheme" }, {
  group = augroup("ModeColorSwitcher"),
  callback = function()
    apply_mode_hl_debounced()
  end,
})
