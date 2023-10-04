return {
    {
        "catppuccin/nvim",
        lazy = false,
        -- event = "VeryLazy",
        -- cond = false,
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd([[colorscheme catppuccin-frappe]])
            vim.cmd([[highlight TabLineSel guibg=cyan]])
            vim.cmd([[highlight GitSignsChange guifg=skyblue]])
            vim.cmd([[highlight IlluminatedWordText guibg=#333333 gui=None]])
            vim.cmd([[highlight IlluminatedWordRead guibg=#333333 gui=None]])
            vim.cmd([[highlight IlluminatedWordWrite guibg=#333333 gui=None]])
            vim.cmd([[highlight LineNr guifg=gray ]])
        end,
    },
}
