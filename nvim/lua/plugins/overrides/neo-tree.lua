-- use custom neo-tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  config = function()
    local components = require("neo-tree.sources.common.components")
    local name_component_config = {
      highlight_opened_files = "all",
    }
    local icons_component_config = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰉖",
      folder_empty_open = "󰷏",
      default = "",
      provider = function(icon, node, state)
        if node.type == "file" or node.type == "terminal" then
          local success, web_devicons = pcall(require, "nvim-web-devicons")
          local name = node.type == "terminal" and "terminal" or node.name
          if success then
            local devicon, hl = web_devicons.get_icon(name)
            icon.text = devicon or icon.text
            icon.highlight = hl or icon.highlight
          end
        end
      end,
    }
    local modified_component_config = {}
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end
    require("neo-tree").setup({
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
        },
        components = {
          name = function(_, node, state)
            local name = components.name(name_component_config, node, state)
            local icon = components.icon(icons_component_config, node, state)
            local modified = components.modified(modified_component_config, node, state)
            return {
              text = icon.text .. name.text,
              highlight = modified and modified.highlight or name.highlight,
            }
          end,
        },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "󰜄",
            modified = "󰏭",
            deleted = "󰛲",
            renamed = "󰰞",
            -- Status type
            untracked = "󰰧",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "󰱞",
          },
        },
      },
      renderers = {
        directory = {
          { "indent" },
          { "current_filter" },
          {
            "container",
            content = {
              { "name", zindex = 10 },
              {
                "symlink_target",
                zindex = 10,
                highlight = "NeoTreeSymbolicLinkTarget",
              },
              { "clipboard", zindex = 10 },
              {
                "diagnostics",
                errors_only = true,
                zindex = 20,
                align = "right",
                hide_when_expanded = true,
                symbols = {
                  error = " ",
                  warn = " ",
                  hint = " ",
                  info = " ",
                },
              },
              { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
              { "file_size", zindex = 10, align = "right" },
              { "type", zindex = 10, align = "right" },
              { "last_modified", zindex = 10, align = "right" },
              { "created", zindex = 10, align = "right" },
            },
          },
        },
        file = {
          { "indent" },
          {
            "container",
            content = {
              {
                "name",
                zindex = 10,
              },
              {
                "symlink_target",
                zindex = 10,
                highlight = "NeoTreeSymbolicLinkTarget",
              },
              { "clipboard", zindex = 10 },
              { "bufnr", zindex = 10 },
              {
                "diagnostics",
                zindex = 20,
                align = "right",
                symbols = {
                  error = " ",
                  warn = " ",
                  hint = " ",
                  info = " ",
                },
              },
              { "git_status", zindex = 10, align = "right" },
              { "file_size", zindex = 10, align = "right" },
              { "type", zindex = 10, align = "right" },
              { "last_modified", zindex = 10, align = "right" },
              { "created", zindex = 10, align = "right" },
            },
          },
        },
        message = {
          { "indent", with_markers = false },
          { "name", highlight = "NeoTreeMessage" },
        },
        terminal = {
          { "indent" },
          { "name" },
          { "bufnr" },
        },
      },
      event_handlers = {
        { event = require("neo-tree.events").FILE_MOVED, handler = on_move },
        { event = require("neo-tree.events").FILE_RENAMED, handler = on_move },
      },
    })
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
    -- Open neo-tree on startup and set options for neo-tree buffer:
    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      callback = function()
        local min_width = 130
        if vim.o.columns >= min_width then
          vim.cmd("Neotree show")
        end
      end,
    })
    -- Auto-toggle Neo-tree on window resize
    vim.api.nvim_create_autocmd("VimResized", {
      pattern = "*",
      callback = function()
        local min_width = 130
        if vim.o.columns >= min_width then
          vim.cmd("Neotree show")
        else
          vim.cmd("Neotree close")
        end
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neo-tree",
      command = "setlocal nolist nospell scrolloff=0 sidescrolloff=0",
    })
    vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { link = "GruvboxGreen" })
    vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { link = "GruvboxRed" })
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "GruvboxOrange" })
    vim.api.nvim_set_hl(0, "NeoTreeGitRenamed", { link = "GruvboxOrange" })
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { link = "GruvboxPurple" })
  end,
}
