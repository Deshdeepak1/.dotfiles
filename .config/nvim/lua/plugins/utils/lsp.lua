return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ui = {
        check_outdated_packages_on_open = true,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- ft = { "python", "lua", "cpp", "html", "css", "javascript", "typescript", "kotlin", "glsl", "markdown" },
    -- cmd = { "LspInfo", "LspStart", "LspInstall", "LspRestart" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()

      local mason_lspconfig_opts = {
        ---@type string[]
        ensure_installed = {
          "markdown_oxide",
          "marksman",
          "basedpyright",
        },

        ---@type boolean
        automatic_installation = false,

        -- See `:h mason-lspconfig.setup_handlers()`
        ---@type table<string, fun(server_name: string)>?
        handlers = nil,
      }

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup(mason_lspconfig_opts)

      ignored_servers = {
        "markdown_oxide",
        "marksman",
      }

      mason_lspconfig.setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function (server_name) -- default handler (optional)
          for _, x in pairs(ignored_servers) do
            if server_name == x then
              return
            end
          end

          config = {}
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          require("lspconfig")[server_name].setup(config)
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --   require("rust-tools").setup {}
        -- end
      })

      -- local opts = { noremap = true, silent = true }
      -- vim.keymap.set('n', '<leader>l', vim.diagnostic.open_float, { desc = "Diagnostic" })
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      -- -- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)
      -- vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, { desc = "DiagList" })
      --
      -- local signature_opts = {
      --   hint_enable = false,
      --   doc_lines = 0,
      -- }
      --
      -- local on_attach = function(client, bufnr)
      --   if client.name == "tsserver" then
      --     client.server_capabilities.documentFormattingProvider = false
      --   end
      --   -- Enable completion triggered by <c-x><c-o>
      --   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      --   local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
      --   if client.server_capabilities.documentFormattingProvider then
      --     -- print(client.server_capabilities)
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = lsp_format_augroup,
      --       buffer = bufnr,
      --       callback = function()
      --         vim.lsp.buf.format({ buffer = bufnr })
      --       end
      --     })
      --   end
      --
      --   local workspace = client.config.root_dir or "./"
      --   local poetry_lock_path = workspace .. "/" .. "poetry.lock"
      --   local is_poetry = vim.fn.filereadable(poetry_lock_path)
      --   if is_poetry == 1 and client.name == "pyright" then
      --     local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
      --     local python_path = venv .. "/" .. "bin/python"
      --     client.config.settings.python.pythonPath = python_path
      --   end
      --
      --   -- Mappings.
      --   -- See `:help vim.lsp.*` for documentation on any of the below functions
      --   local keymap = function(mode, lhs, rhs, def_opts)
      --     def_opts = def_opts or {}
      --     -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
      --     def_opts.buffer = bufnr
      --     def_opts.noremap = true
      --     def_opts.silent = true
      --     vim.keymap.set(mode, lhs, rhs, def_opts)
      --   end
      --
      --   keymap('n', 'gD', vim.lsp.buf.declaration, { desc = "Declaration" })
      --   keymap('n', 'gd', vim.lsp.buf.definition, { desc = "Definition" })
      --   keymap('n', 'K', vim.lsp.buf.hover, { desc = "Documentation" })
      --   keymap('n', 'gI', vim.lsp.buf.implementation, { desc = "Implementation" })
      --   keymap('n', '<leader>k', vim.lsp.buf.signature_help, { desc = "SigHelp" })
      --   keymap('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "TypeDef" })
      --   keymap('n', '<leader>R', vim.lsp.buf.rename, { desc = "Rename" })
      --   keymap('n', '<F2>', vim.lsp.buf.rename, { desc = "Rename" })
      --   keymap('n', '<leader>a', vim.lsp.buf.code_action, { desc = "CodeAction" })
      --   keymap('n', 'gr', vim.lsp.buf.references, { desc = "References" })
      --   keymap('n', '<leader>F', vim.lsp.buf.format, { desc = "Format" })
      --
      --   require("lsp_signature").on_attach(signature_opts, bufnr)
      --
      --   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      --     vim.lsp.buf.format()
      --   end, {})
      -- end
      --
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


      local lsp_opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      local servers_opts = {
        gopls = {},
        ruff_lsp = {
          init_options = {
            settings = {
              -- Any extra CLI arguments for `ruff` go here.
              -- args = { "--line-length=999", },
              -- args = { "--ignore", "E501" },
              lint = { args = {} },
              -- format = { args = { "--line-length=150", } }
            },

          },

        },
        ruff = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          },

        },
        pyright = {

          capabilities = {
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },

          settings = {
            pyright = {
              -- disableOrganizeImports = true,

            },
            python = {
              hint = { enable = false },
              analysis = {
                -- ignore = { '*' },

                autoSearchPaths = true,
                diagnosticMode = "workspace",
                -- typeCheckingMode = "basic",
                typeCheckingMode = "basic",
                diagnosticSeverityOverrides = {
                },
              }
            }
          },
        },

        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
              },
            },
          },
        },

        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeys[]
          -- keys = {},
          settings = {
            Lua = {
              format = {
                enable = false,
              },
              diagnostics = {
                -- disable = { "missing-parameter" },
                globals = { "vim" },
              },
              -- log_level = 5,
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                }
              },
              completion = {
                callSnippet = "Replace",
              },
            }
          }
        },

        clangd = {

        },
        neocmake = { },

        tsserver = {

        },

        cssls = {},
        tailwindcss = {},

        kotlin_language_server = {

        },

        glsl_analyzer = {

        },




      }

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      local default_diagnostic_config = {
        underline = false,
        -- disable virtual text
        -- virtual_text = true, -- TODO: Signs for low level
        virtual_text = false,
        -- show signs
        -- signs = {
        --  active = signs,
        -- },
        -- signs = false,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          -- focusable = false,
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(default_diagnostic_config)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
    end,
  },
  -- {
  --     "folke/trouble.nvim",
  --     -- lazy = false,
  --     opts = {
  --         -- your configuration comes here
  --         -- or leave it empty to use the default settings
  --         -- refer to the configuration section below
  --     },
  --
  -- }
  -- {
  --   'mrcjkb/haskell-tools.nvim',
  --   cond = false,
  --   version = '^3', -- Recommended
  --   lazy = false, -- This plugin is already lazy
  -- }
}
