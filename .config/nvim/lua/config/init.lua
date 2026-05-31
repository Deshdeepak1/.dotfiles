require("config.settings")
require("config.keymaps")
require("config.autocmds")
-- NOTE: config.lsp is loaded in init.lua AFTER lazy-config,
-- so that mason can patch PATH before vim.lsp.enable() runs.
