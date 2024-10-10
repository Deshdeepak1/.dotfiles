return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    -- event = "CursorMoved",
    -- cond = false,
    -- dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        -- vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]
        vim.cmd [[highlight IblScope guifg=lightblue gui=nocombine]]
        require("ibl").setup({
            indent = {
                char = "▏",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
                injected_languages = true,
            },
        })
    end
}
