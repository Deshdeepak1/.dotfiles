return {
    "iamcco/markdown-preview.nvim",
    -- event = "VeryLazy",
    -- cmd = { "MarkdownPreviewToggle" },
    ft = { "markdown", "quarto" },
    -- cond = false,
    cond = not vim.g.started_by_firenvim,
    -- init = function()
    --     vim.fn["mkdp#util#install"]()
    --     vim.g.mkdp_filetypes = { "markdown", "quarto" }
    -- end,
    config = function()
        vim.fn["mkdp#util#install"]()
        vim.g.mkdp_filetypes = { "markdown", "quarto" }
    end,
}
