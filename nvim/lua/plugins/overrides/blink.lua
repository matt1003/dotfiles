-- set <tab> for auto-completion and enable borders on pop-ups
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      -- set rounded border on selection menu pop-up:
      menu = {
        border = "rounded",
      },
      -- set rounded border on documentation pop-up:
      documentation = {
        window = {
          border = "rounded",
        },
      },
    },
    -- set rounded border on signature pop-up:
    signature = {
      window = {
        border = "rounded",
      },
    },
    -- set <tab> for auto-completion:
    keymap = {
      preset = "super-tab",
    },
  },
  init = function()
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Search" })
  end,
}
