return {
  {
    'echasnovski/mini.nvim',
    event = "VeryLazy",
    config = function()
      local splitjoin = require('mini.splitjoin')  -- TODO: Learn gS
      splitjoin.setup()
    end
  },
}
