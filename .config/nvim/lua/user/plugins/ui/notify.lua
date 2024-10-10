return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    -- cond = false,
    config = function()
        require('notify').setup({
            -- other stuff
            background_colour = "#000000"
        })
    end,
}
