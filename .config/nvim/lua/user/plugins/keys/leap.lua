return {
    "ggandor/leap.nvim",
    -- cond = false,
    -- event = "VeryLazy",
    keys = { "s", "S" },
    -- lazy = false,
    config = function()
        require('leap').add_default_mappings()
    end,
}
