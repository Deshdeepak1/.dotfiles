return {
  {
    "echasnovski/mini.splitjoin", -- TODO: Learn gS
    -- cond = false,
    version = "*",
    keys = { "gS" },
    opts = {},
  },
  {
    "echasnovski/mini.notify",
    cond = false,
    -- lazy = false,
    event = "VeryLazy",
    version = "*",
    -- opts = {},
    config = function()
      require("mini.notify").setup({
        window = {
          config = { border = "solid" },
        },
        content = {
          format = function(notif)
            return notif.msg .. " Hello"
          end,
        },
      })
      vim.notify = require("mini.notify").make_notify()
    end,
  },
}
