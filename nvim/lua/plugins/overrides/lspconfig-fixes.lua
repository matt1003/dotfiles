-- fixes for lsp config
local util = require("lspconfig.util")
return {
  -- nvim-lspconfig changes:
  -- * Old configs in `lua/lspconfig/configs/*` are deprecated and will be removed.
  -- * New configs live in `lsp/*` and are enabled with `vim.lsp.enable('…')`.
  --
  -- Why this matters:
  -- * lua/lspconfig/configs/biome.lua always uses the globally installed biome.
  -- * lsp/biome.lua prefers the local biome (node_modules/.bin/biome), falling
  --   back to global.
  --
  -- Current issue:
  -- * LazyVim still pulls from the deprecated configs.
  --
  -- Temporary fix:
  -- * See https://github.com/LazyVim/LazyVim/pull/6053 for the upstream solution.
  -- * Until that lands, I’ve copied `lsp/biome.lua` here.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {
          cmd = function(dispatchers, config)
            local cmd = "biome"
            local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
            if local_cmd and vim.fn.executable(local_cmd) == 1 then
              cmd = local_cmd
            end
            return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
          end,
          filetypes = {
            "astro",
            "css",
            "graphql",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "jsonc",
            "svelte",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "vue",
          },
          workspace_required = true,
          root_dir = function(_, bufnr)
            -- The project root is where the LSP can be started from
            -- As stated in the documentation above, this LSP supports monorepos and simple projects.
            -- We select then from the project root, which is identified by the presence of a package
            -- manager lock file.
            local root_markers =
              { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "deno.lock" }
            -- Give the root markers equal priority by wrapping them in a table
            root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
            local project_root = vim.fs.root(bufnr, root_markers)
            if not project_root then
              return
            end

            -- We know that the buffer is using Biome if it has a config file
            -- in its directory tree.
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local biome_config_files = { "biome.json", "biome.jsonc" }
            biome_config_files = util.insert_package_json(biome_config_files, "biome", filename)
            local is_buffer_using_biome = vim.fs.find(biome_config_files, {
              path = filename,
              type = "file",
              limit = 1,
              upward = true,
              stop = vim.fs.dirname(project_root),
            })[1]
            if not is_buffer_using_biome then
              return
            end

            return project_root
          end,
        },
      },
    },
  },
  -- vue/typescript intergration
  --
  -- Current issue:
  -- * Since v3.0.0, vue-language-server no longer runs its own tsserver or manages
  --   hybrid mode communication. Instead, whenever TypeScript features are needed,
  --   it issues a custom LSP request ("tsserver/request") to the editor, which must
  --   forward the request to tsserver and return the response.
  --
  -- Temporary fix:
  -- * See https://github.com/LazyVim/LazyVim/pull/6238 for the upstream solution.
  -- * Until that lands, I’ve copied that fix here.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = { -- when LazyVim switches to nvim-lspconfig ≥ v2.2.0 rename this to `vue_ls`
          on_init = function(client)
            client.handlers["tsserver/request"] = function(_, result, context)
              -- find the vtsls client
              local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
              if #clients == 0 then
                vim.notify("Could not find `vtsls` client, Vue LSP features will be disabled", vim.log.levels.ERROR)
                return
              end
              local ts_client = clients[1]
              -- unpack the forwarded request
              local params = unpack(result)
              local id, command, payload = unpack(params)
              -- forward it
              ts_client:exec_cmd({
                title = "vue_request_forward",
                command = "typescript.tsserverRequest",
                arguments = { command, payload },
              }, { bufnr = context.bufnr }, function(_, resp)
                -- send the tsserver/response back to Vue LSP
                client.notify("tsserver/response", { { id, resp.body } })
              end)
            end
          end,
        },
      },
    },
  },
}
