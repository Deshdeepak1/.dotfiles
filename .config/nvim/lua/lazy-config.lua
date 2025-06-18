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

ensure_lazy()

vim.opt.rtp:prepend(lazypath)

local lazy_st_ok, lazy = pcall(require, "lazy")
if not lazy_st_ok then return end

--- @type LazyConfig
local lazy_opts = {
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "catppuccin-frappe", "habamax" } },
  checker = { enabled = false },
  ui = { border = "rounded", title = "Lazy" },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },
}

lazy.setup({
  { import = "plugins" },
}, lazy_opts)
