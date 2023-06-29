local ok, wk = pcall(require, "which-key")
if not ok then
    return
end
wk.register({
    ["1"] = { "Buffer 1" },
    ["2"] = { "Buffer 2" },
    ["3"] = { "Buffer 3" },
    ["4"] = { "Buffer 4" },
    ["5"] = { "Buffer 5" },
    ["6"] = { "Buffer 6" },
    ["7"] = { "Buffer 7" },
    ["8"] = { "Buffer 8" },
    ["9"] = { "Buffer 9" },
    ["/"] = { "Comment" },
    g = {
        name = "Git",
        h = { "<cmd>SignifyToggleHighlight<cr>", "Highlight" },
        t = { "<cmd>SignifyToggle<cr>", "Toggle" },
        s = { "<cmd>G<cr>", "Status" },
        d = { "<cmd>Gvdiffsplit<cr>", "DiffSplit" },
        D = { "<cmd>G diff<cr>", "Diff" },
        a = { "<cmd>Gw<cr>", "Add" },
        A = { "<cmd>G add .<cr>", "AddCDir" },
        r = { "<cmd>GDelete<cr>", "Remove" },
        R = { "<cmd>GRename<cr>", "Rename" },
        c = { "<cmd>G commit<cr>", "Commit" },
        p = { "<cmd>G push<cr>", "Push" },
        P = { "<cmd>G pull<cr>", "Pull" },
        f = { "<cmd>G fetch<cr>", "Fetch" },
        l = { "<cmd>Gclog<cr>", "Log" },
        C = { "<cmd>GBranches<cr>", "Checkout" },
        bb = { "<cmd>G blame<cr>", "Blame" },
        B = { "<cmd>GBrowse<cr>", "Browse" },
        cc = { "<cmd>GV!<cr>", "Commits" },
        CC = { "<cmd>GV<cr>", "AllCommits" },
        F = { "<cmd>G add<Space>", "CustAdd" },
        m = { "<cmd>GMove<Space>", "Move" },
        b = { "<cmd>G branch ", "Branch" },
    },
    e = { "<cmd>NvimTreeFindFileToggle<cr>", "Explorer" },
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
    h = {
        name = "Hunk",
        s = "Stage Hunk",
        S = "Stage Buffer",
        r = "Reset Hunk",
        R = "Reset Buffer",
        u = "Undo Stage Hunk",
        p = "Preview Hunk",
        t = "Toggle Hunk",
        b = "Blame Line",
        B = "Blame Line full",
        T = "Blame Line Toggle",
        d = "DiffSplit",
        D = "DiffSplit ~",

    },
    t = {
        name = "Terminal",
        t = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
        v = { "<cmd>ToggleTerm direction=vertical size=45<CR>", "Vertical" },
        h = { "<cmd>ToggleTerm direction=horizontal size=15<CR>", "Horizontal" },
        l = { "<cmd>ToggleTermSendCurrentLine<CR>", "Send Line" },
        p = { "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd='python3', direction='float'}):toggle()<CR>",
            "python" },
        P = { "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd='python3', direction='horizontal', size=15}):toggle()<CR>",
            "python" },
    },
    r = {
        name = "Run",
        p = { "<cmd>TermExec cmd='python3 %' direction=float<CR>", "python" },
        P = { "<cmd>TermExec cmd='python3 %' direction=horizontal<CR> size=15", "python" },
    }
}, { mode = "n", prefix = "<leader>" })
wk.register({
    t = {
        name = "Terminal",
        l = { "<cmd>ToggleTermSendVisualLine<CR>", "Send Line" },
        s = { "<cmd>ToggleTermSendVisualSelection<CR>", "Send Visual Selection" },
    }
}, { mode = "v", prefix = "<leader>" })
wk.register({
    t = {
        name = "Terminal",
        t = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
        v = { "<cmd>ToggleTerm direction=vertical size=45<CR>", "Vertical" },
        h = { "<cmd>ToggleTerm direction=horizontal size=15<CR>", "Horizontal" },
        -- l = { "<cmd>ToggleTermSendCurrentLine<CR>", "Send Line" },
    }
}, { mode = "t", prefix = "<leader>" })
wk.setup()
