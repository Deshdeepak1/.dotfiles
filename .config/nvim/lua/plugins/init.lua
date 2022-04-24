require "plugins.cmp"
require "plugins.telescope"
require "plugins.treesitter"
require "plugins.autopairs"
require "plugins.comment"
-- require "plugins.gitsigns"
require "plugins.which-key"
-- require "plugins.toggleterm"
require "plugins.floaterm"
require "plugins.nvim-tree"
-- require "plugins.lualine"
require "plugins.indentline"
require "plugins.mini"
require "plugins.colorizer"
require "plugins.colorscheme"
require "plugins.airline"

-- local status_ok, alpha = pcall(require, "alpha")
-- if not status_ok then
--     return
-- end
-- alpha.setup(require'alpha.themes.startify'.config)

-- vim.g.cursorhold_updatetime = 100
--require('auto-session').setup {
--}


local st_ok, impatient = pcall(require, "impatient")
if st_ok then
    impatient.enable_profile()
end
