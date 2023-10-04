return {
    "numToStr/Comment.nvim",
    -- event = "VeryLazy",
    -- cond = false,
    keys = {
        {
            "<leader>/",
            '<cmd>lua require"Comment.api".toggle.linewise()<cr>',
            mode = "n",
            desc =
            "Comment Toggle"
        },
        {
            "<leader>/",
            '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
            mode = "x",
            desc =
            "Comment Toggle"
        },
        { "gc" },
        { "gb" },
    },
    config = function()
        require('Comment').setup {
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
    end,
}
