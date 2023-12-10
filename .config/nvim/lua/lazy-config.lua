-- Lazy (Plugin Managerplugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local ensure_lazy = function()
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
        return true
    end
    return false
end
vim.opt.rtp:prepend(lazypath)

local lazy_bootstrap = ensure_lazy()

local lazy_st_ok, lazy = pcall(require, "lazy")
if not lazy_st_ok then
    return
end

local lazy_opts = {
    defaults = { lazy = true },
    install = { colorscheme = { "catppuccin-frappe", "habamax" } },
    ui = { border = "rounded", title = "Lazy" },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false, -- get a notification when changes are found
    }
}

lazy.setup({
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },

    { import = "lazy-plugins.keys" },
    { import = "lazy-plugins.utils" },
    { import = "lazy-plugins.git" },
    { import = "lazy-plugins.ui" },
    { import = "lazy-plugins.neorg" },
}, lazy_opts)


-- Taking inputs
-- vim.ui.input({ prompt = 'Enter value for shiftwidth: ' }, function(input)
--     vim.o.shiftwidth = tonumber(input)
-- end)
