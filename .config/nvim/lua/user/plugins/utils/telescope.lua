return {
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.8",
        -- event = "VeryLazy",
        -- cond = false,
        cond = not vim.g.started_by_firenvim,
        cmd = "Telescope",
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        keys = {
            { "<leader>fB", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
            { "<leader>fC", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
            { "<leader>fG", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
            { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
            { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Status" },
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
