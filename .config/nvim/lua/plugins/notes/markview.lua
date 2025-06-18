---@module "lazy"
---@type LazySpec
return {
  {
    "OXY2DEV/markview.nvim",
    -- enabled = false,
    cond = false,
    -- lazy = false,
    event = "VeryLazy",

    dependencies = {
      "saghen/blink.cmp",
    },
    ---@module "markview"
    ---@type mkv.config
    opts = {
      markdown = {
        headings = {
          enable = true,
        },
      },
    },
    config = function(_, opts)
      mkv = require("markview")
      mkv.setup(opts)
      vim.api.nvim_set_hl(0, "MarkviewHeading1", { link = "@markup.heading.1" })
      vim.api.nvim_set_hl(0, "MarkviewHeading2", { link = "@markup.heading.2" })
      vim.api.nvim_set_hl(0, "MarkviewHeading3", { link = "@markup.heading.3" })
      vim.api.nvim_set_hl(0, "MarkviewHeading4", { link = "@markup.heading.4" })
      vim.api.nvim_set_hl(0, "MarkviewHeading5", { link = "@markup.heading.5" })
      vim.api.nvim_set_hl(0, "MarkviewHeading6", { link = "@markup.heading.6" })
    end,
  },
}
