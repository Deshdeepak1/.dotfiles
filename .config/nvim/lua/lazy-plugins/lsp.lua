return {
    {
        "neovim/nvim-lspconfig",
        -- event = "VeryLazy",
        event = { "BufReadPre", "BufNewFile" },
        -- lazy = false,
        ft = { "python", "lua" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
            "ray-x/lsp_signature.nvim",
        },
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                },
            })

            require("neodev").setup({

            })

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup({
                ensure_installed = {
                    "lua_ls",
                    "pylsp",
                    "pyright",
                },
            })

            local opts = { noremap = true, silent = true }
            vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Diagnostic" })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            -- vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)
            vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, { desc = "DiagList" })

            local signature_opts = {
                hint_enable = false,
                doc_lines = 0,
            }

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                -- if client.name == "pyright" then
                --     vim.api.nvim_command('autocmd BufWritePost <buffer> silent !black %')
                -- end
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_command('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')
                end

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local keymap = function(mode, lhs, rhs, opts)
                    opts = opts or {}
                    -- local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    opts.buffer = bufnr
                    opts.noremap = true
                    opts.silent = true
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                keymap('n', 'gD', vim.lsp.buf.declaration, { desc = "Declaration" })
                keymap('n', 'gd', vim.lsp.buf.definition, { desc = "Definition" })
                keymap('n', 'K', vim.lsp.buf.hover, { desc = "Documentation" })
                keymap('n', 'gI', vim.lsp.buf.implementation, { desc = "Implementation" })
                keymap('n', '<leader>k', vim.lsp.buf.signature_help, { desc = "SigHelp" })
                keymap('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "TypeDef" })
                keymap('n', '<leader>R', vim.lsp.buf.rename, { desc = "Rename" })
                keymap('n', '<F2>', vim.lsp.buf.rename, { desc = "Rename" })
                keymap('n', '<leader>a', vim.lsp.buf.code_action, { desc = "CodeAction" })
                keymap('n', 'gr', vim.lsp.buf.references, { desc = "References" })
                keymap('n', '<leader>F', function() vim.lsp.buf.format() end, { desc = "Format" })

                require "lsp_signature".on_attach(signature_opts, bufnr)

                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, {})
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local ignored_servers = {
                "pylsp",
            }

            local lsp_opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            local servers_opts = {
                pyright = {
                    settings = {

                        python = {
                            analysis = {
                                typeCheckingMode = "off"
                            }
                        }
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
                            diagnostics = {
                                -- disable = { "missing-parameter" },
                            },
                            -- log_level = 5,
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        }
                    }
                }

            }


            mason_lspconfig.setup_handlers({
                function(server_name)
                    for _, x in pairs(ignored_servers) do
                        if server_name == x then
                            return
                        end
                    end
                    local server_opts = vim.tbl_deep_extend("force", servers_opts[server_name], lsp_opts)

                    require("lspconfig")[server_name].setup(server_opts)
                end
            })

            local signs = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            }

            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            local config = {
                -- disable virtual text
                virtual_text = true,
                -- show signs
                --signs = {
                --  active = signs,
                --},
                -- signs = false,
                signs = false,
                update_in_insert = false,
                -- undercurl = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }

            vim.diagnostic.config(config)
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })
        end,
    },
    -- {
    --     "mfussenegger/nvim-dap",
    --     event = "VeryLazy",
    --     -- config = true,
    -- }
}