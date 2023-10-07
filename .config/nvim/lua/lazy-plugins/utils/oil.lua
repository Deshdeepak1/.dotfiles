return {
    'stevearc/oil.nvim',
    lazy = false,
    -- event = "VeryLazy",
    -- cond = false,
    cond = not vim.g.started_by_firenvim,
    -- opts = {},
    config = function()
        local oil = require("oil")
        oil.setup({
            columns = {
                "icon",
                -- "permissions",
            },
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["Q"] = "actions.close",
                ["<leader>t"] = "actions.open_terminal",
                ["<leader>T"] = {
                    desc = "Toggle detail view",
                    callback = function()
                        local oil = require("oil")
                        local config = require("oil.config")
                        if #config.columns == 1 then
                            oil.set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            oil.set_columns({ "icon" })
                        end
                    end,
                },
            },
            float = {
                max_height = 40,
                max_width = 100,
                win_options = { winblend = 0 },
                -- override = function(conf)
                --     return conf
                -- end,
            },
        })
        vim.keymap.set("n", "<leader>e", oil.toggle_float, { noremap = true, desc = "Oil Toggle" })
    end,
}
