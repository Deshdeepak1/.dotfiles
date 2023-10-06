return {
    "nvimtools/none-ls.nvim",
    -- event = "VeryLazy",
    ft = { "python", },
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    config = function()
        local null_ls = require("null-ls")
        require("mason-null-ls").setup({
            ensure_installed = {
                -- "mypy",
                -- "ruff",
                "black",
            }
        })
        null_ls.setup({
            sources = {
                -- null_ls.builtins.diagnostics.mypy,
                -- null_ls.builtins.diagnostics.ruff,
                null_ls.builtins.formatting.black,
            },
            on_attach = function(client, buffer)
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_command('autocmd BufWritePre <buffer> lua vim.lsp.buf.format()')
                end
            end,
        })
    end
}
