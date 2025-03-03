return {
  {
    "echasnovski/mini.nvim",
    -- cond = false,
    event = "VeryLazy",
    config = function()
      local splitjoin = require("mini.splitjoin") -- TODO: Learn gS
      splitjoin.setup()
    end,
  },
}
