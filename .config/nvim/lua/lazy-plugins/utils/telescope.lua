return {
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.2",
        -- event = "VeryLazy",
        -- cond = false,
        cond = not vim.g.started_by_firenvim,
        cmd = "Telescope",
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtins = require("telescope.builtin")

            local picker_config = {}
            for b, _ in pairs(builtins) do
                picker_config[b] = { layout_config = { preview_width = 0.55 } }
            end
            telescope.setup({
                defaults = {

                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                },
                pickers = picker_config,
            })
            telescope.load_extension('fzf')
        end,
    },
}
