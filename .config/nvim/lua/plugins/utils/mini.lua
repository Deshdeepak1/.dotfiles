return {
  {
    'echasnovski/mini.nvim',
    event = "VeryLazy",
    config = function()
      local statusline = require('mini.statusline')
      statusline.setup({ use_icons = true })
      local pairs = require('mini.pairs')
      pairs.setup()
    end
  },
}
