return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    -- cond = false,
    opts = {
      ui = {
        check_outdated_packages_on_open = true,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- lazy = false,
    -- cond = false,
    -- ft = { "python", "lua", "cpp", "html", "css", "javascript", "typescript", "kotlin", "glsl", "markdown" },
    -- cmd = { "LspInfo", "LspStart", "LspInstall", "LspRestart" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local mason_lspconfig_opts = {
        ---@type string[]
        ensure_installed = {
          -- Lsp
          "lua_ls",
          "markdown_oxide",
          "marksman",
          "basedpyright",
          "ruff",
          "clangd",
        },

        ---@type boolean
        automatic_installation = false,

        -- See `:h mason-lspconfig.setup_handlers()`
        ---@type table<string, fun(server_name: string)>?
        handlers = nil,
      }

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup(mason_lspconfig_opts)

      local servers_configs = {
        lua_ls = {
          settings = {
            Lua = {
              format = {
                enable = false,
                -- Put format options here
                -- NOTE: the value should be String!
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                },
              },
              diagnostics = {},
            },
          },
        },

        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                inlayHints = {},
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                diagnosticSeverityOverrides = {},
              },
            },
          },
        },

        ruff = {
          init_options = {
            settings = {
              logLevel = "debug",
            },
          },
        },
      }

      local ignored_servers = {
        "markdown_oxide",
        "marksman",
      }

      mason_lspconfig.setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          for _, x in pairs(ignored_servers) do
            if server_name == x then
              return
            end
          end

          local server_config = vim.deepcopy(servers_configs[server_name] or {})
          local config = vim.tbl_deep_extend("force", server_config, {})
          -- config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          require("lspconfig")[server_name].setup(config)
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --   require("rust-tools").setup {}
        -- end
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          -- if client.supports_method('textDocument/inlayHints') then
          --   vim.lsp.inlay_hint.enable()
          -- end

          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          client.server_capabilities.documentFormattingProvider = false
          -- if client.name == "tsserver" then
          --   client.server_capabilities.documentFormattingProvider = false
          -- end
          -- if client.supports_method('textDocument/formatting') then
          --   local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
          --   vim.api.nvim_create_autocmd("BufWritePre", {
          --     group = lsp_format_augroup,
          --     buffer = args.buf,
          --     callback = function()
          --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          --     end
          --   })
          -- end
        end,
      })

      local keymap = function(mode, lhs, rhs, opts)
        local default_opts = { noremap = true, silent = true }
        vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, default_opts))
      end

      keymap("n", "<leader>lf", vim.diagnostic.open_float, { desc = "DiagFloat" })
      keymap("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "DiagList" })
      keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "DiagPrev" })
      keymap("n", "]d", vim.diagnostic.goto_next, { desc = "DiagNext" })
      keymap("n", "[w", function()
        vim.diagnostic.goto_prev({ severity = "WARN" })
      end, { desc = "WarnPrev" })
      keymap("n", "]w", function()
        vim.diagnostic.goto_next({ severity = "WARN" })
      end, { desc = "WarnNext" })
      keymap("n", "[e", function()
        vim.diagnostic.goto_prev({ severity = "ERROR" })
      end, { desc = "ErrorPrev" })
      keymap("n", "]e", function()
        vim.diagnostic.goto_next({ severity = "ERROR" })
      end, { desc = "ErrorNext" })

      keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
      keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
      keymap("n", "K", vim.lsp.buf.hover, { desc = "Documentation" })
      keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })
      keymap("n", "grn", vim.lsp.buf.rename, { desc = "Rename" })
      keymap("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
      keymap("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" })
      keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "CodeAction" })
      keymap("n", "<leader>lk", vim.lsp.buf.signature_help, { desc = "SigHelp" })
      keymap("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "TypeDef" })
      keymap("n", "<leader>lF", vim.lsp.buf.format, { desc = "Format" })

      keymap("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        vim.notify(
          "InlayHints=" .. tostring(vim.lsp.inlay_hint.is_enabled()),
          vim.log.levels.INFO,
          { id = "inlayhints" }
        )
      end, { desc = "InlayHintsToggle" })

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
        underline = true,
        virtual_text = true, -- TODO: Signs for low level
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
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
}
