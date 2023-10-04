return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    -- keys = { "<leader>g" },
    -- cmd = { "G" },
    cond = function()
        -- return false
        local is_git = vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
    end,
    dependencies = { "tpope/vim-rhubarb" }
    -- local is_git = vim.api.nvim_command_output("!git rev-parse --is-inside-work-tree")
}
