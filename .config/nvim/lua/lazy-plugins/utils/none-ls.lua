return {
    "nvimtools/none-ls.nvim",
    -- event = "VeryLazy",
    ft = { "python", "javascript" },
    cmd = { "NullLsInfo" },
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    config = function()
        local null_ls = require("null-ls")
        require("mason-null-ls").setup({
            ensure_installed = {
                -- "mypy",
                -- "ruff",
                "black",
                "prettier",
            }
        })
        local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
        null_ls.setup({
            sources = {
                -- null_ls.builtins.diagnostics.mypy,
                -- null_ls.builtins.diagnostics.ruff,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.prettier,
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
