return {
    "nvimtools/none-ls.nvim",
    -- event = "VeryLazy",
    ft = { "python", "html", "css", "javascript", "typescript", },
    cmd = { "NullLsInfo" },
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    config = function()
        local null_ls = require("null-ls")
        require("mason-null-ls").setup({
            ensure_installed = {
                -- "mypy",
                -- "isort",
                -- "black",
                "prettierd",
                "ktlint",
            }
        })

        local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
        null_ls.setup({
            sources = {
                -- null_ls.builtins.diagnostics.mypy,
                null_ls.builtins.diagnostics.ktlint,

                -- null_ls.builtins.formatting.isort,
                -- null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { "markdown", "yaml" },
                }),
                null_ls.builtins.formatting.ktlint,

            },
            on_attach = function(client, bufnr)
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_clear_autocmds({
                        buffer = bufnr,
                        group = lsp_format_augroup,
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = lsp_format_augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ buffer = bufnr })
                        end
                    })
                end
            end,
        })
    end
}
