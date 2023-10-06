return {
    "folke/which-key.nvim",
    -- cond = false,
    cond = not vim.g.started_by_firenvim,
    -- keys = { "<leader>" },
    event = "VeryLazy",
    priority = 0,
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
            n = {
                name = "Neorg",
                w = { ":Neorg workspace ", "Workspace" },
                n = { ":Neorg workspace notes<cr>", "Notes Workspace" },
                i = { ":Neorg index<cr>", "Index" },
                r = { ":Neorg return<cr>", "Return" },
            },
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
}
