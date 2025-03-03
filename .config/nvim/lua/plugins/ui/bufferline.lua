return {
    'akinsho/bufferline.nvim',
    version = "*",
    -- cond = false,
    event = "VeryLazy",
    -- cond = false,
    -- cond = not vim.g.started_by_firenvim,
    config = function()
        local buffer_bg = '#232627'
        local bufferline = require("bufferline")
        bufferline.setup({
            options = {
                themable = true,
                numbers = "ordinal",
                indicator = { style = 'underline' },
                buffer_close_icon = '',
                modified_icon = '󰧞',
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = true,
                show_close_icon = false,
                show_tab_indicators = false,
                always_show_bufferline = false,
                persist_buffer_sort = false,
                separator_style = "slant",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' }
                },
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get(),

            -- highlights = {
            --     fill = {
            --         bg = buffer_bg,
            --     },
            --     separator_selected = {
            --         fg = buffer_bg,
            --         -- bg = 'black',
            --     },
            --     separator = {
            --         fg = buffer_bg,
            --         -- bg = 'black',
            --     },
            --     separator_visible = {
            --         fg = buffer_bg,
            --         -- bg = 'black',
            --     },
            -- }
        })
        for i = 1, 9 do
            vim.keymap.set('n', ('<A-%s>'):format(i),
                (':lua require("bufferline").go_to(%d, true)<cr>'):format(i),
                { silent = true, desc = ('Buffer %s'):format(i) })
        end
        vim.keymap.set('n', "<leader>bp", ":BufferLinePick<cr>", { silent = true, desc = "Pick Buffer" })
        vim.keymap.set('n', "<leader>bd", ":BufferLinePickClose<cr>", { silent = true, desc = "Close Buffer" })
    end,
}
