return {
    "ThePrimeagen/harpoon",
    -- cond = false,
    -- event = "VeryLazy",
    keys = {
        "<leader>A",
        "<leader>m",
    },
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
}
