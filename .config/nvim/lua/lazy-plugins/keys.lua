return {

    -- Actions
    {
        "numToStr/Comment.nvim",
        -- event = "VeryLazy",
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
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            fast_wrap = {},
        }
    },

    -- Jumps
    -- {
    --     'phaazon/hop.nvim',
    --     lazy = false,
    --     branch = 'v2', -- optional but strongly recommended
    --     config = function()
    --         -- you can configure Hop the way you like here; see :h hop-config
    --         require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    --         -- place this in one of your configuration file(s)
    --         local hop = require('hop')
    --         local directions = require('hop.hint').HintDirection
    --         vim.keymap.set('', 'f', function()
    --           hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    --         end, {remap=true})
    --         vim.keymap.set('', 'F', function()
    --           hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    --         end, {remap=true})
    --         vim.keymap.set('', 't', function()
    --           hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    --         end, {remap=true})
    --         vim.keymap.set('', 'T', function()
    --           hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    --         end, {remap=true})
    --         vim.keymap.set("n", "s", "<cmd>HopChar2<CR>", { remap = true })
    --         vim.keymap.set("n", "S", "<cmd>HopWord<CR>", { remap = true })
    --     end
    -- },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        -- lazy = false,
        config = function()
            require('leap').add_default_mappings()
        end,
    },
    {
        "ThePrimeagen/harpoon",
        event = "VeryLazy",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>A", mark.add_file, { desc = "HarpoonAdd" })
            vim.keymap.set("n", "<leader>m", ui.toggle_quick_menu, { desc = "HarpoonMenu" })

            vim.keymap.set("n", "<M-1>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<M-2>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<M-3>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<M-3>", function() ui.nav_file(4) end)
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        keys = { "<leader>" },
        -- event = "VeryLazy",
        -- init = function()
        --   vim.o.timeout = true
        --   vim.o.timeoutlen = 300
        -- end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        config = function()
            local ok, wk = pcall(require, "which-key")
            wk.register({
                g = {
                    name = "Git",
                    -- h = { "<cmd>SignifyToggleHighlight<cr>", "Highlight" },
                    -- t = { "<cmd>SignifyToggle<cr>", "Toggle" },
                    s = { "<cmd>G<cr>", "Status" },
                    d = { "<cmd>Gvdiffsplit<cr>", "DiffSplit" },
                    D = { "<cmd>G diff<cr>", "Diff" },
                    a = { "<cmd>Gw<cr>", "Add" },
                    A = { "<cmd>G add .<cr>", "AddCDir" },
                    F = { ":G add ", "CustAdd" },
                    -- r = { ":GRename ", "Rename" },
                    r = { ":GMove ", "Move/Rename" },
                    R = { "<cmd>GDelete<cr>", "Remove" },
                    c = { "<cmd>G commit<cr>", "Commit" },
                    p = { "<cmd>G push<cr>", "Push" },
                    P = { "<cmd>G pull<cr>", "Pull" },
                    f = { "<cmd>G fetch<cr>", "Fetch" },
                    l = { "<cmd>Gclog<cr>", "Log" },
                    C = { ":G checkout ", "Checkout" },
                    b = { "<cmd>G branch<cr>", "branches" },
                    bb = { "<cmd>G blame<cr>", "Blame" },
                    B = { "<cmd>GBrowse<cr>", "Browse" },
                },
                h = "Hunk",
                c = "QuickFix",
            }, { mode = "n", prefix = "<leader>", silent = false })
            wk.register({ b = "Buffer" }, { mode = "n", prefix = "<leader>" })
            wk.register({
                f = {
                    name = "Telescope",
                    f = { "<cmd>Telescope find_files<cr>", "Files" },
                    r = { "<cmd>Telescope oldfiles<cr>", "Recent" },
                    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
                    h = { "<cmd>Telescope help_tags<cr>", "Help" },
                    C = { "<cmd>Telescope git_commits<cr>", "Commits" },
                    G = { "<cmd>Telescope git_files<cr>", "Git Files" },
                    B = { "<cmd>Telescope git_branches<cr>", "Branches" },
                    s = { "<cmd>Telescope git_status<cr>", "Status" },
                    c = { "<cmd>Telescope commands<cr>", "Commands" },
                    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
                    d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
                    m = { "<cmd>Telescope marks<cr>", "Marks" },
                    M = { "<cmd>Telescope man_pages<cr>", "Man" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
    },
}
