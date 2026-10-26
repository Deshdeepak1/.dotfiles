---@module "lazy"
---@type LazySpec
local ai = require("config.ai")

return {
  {
    "zbirenbaum/copilot.lua",
    cond = ai.copilot,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- handled by blink
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },
  {
    "fang2hou/blink-copilot",
    cond = ai.copilot,
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    specs = {
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            default = { "copilot" },
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 100,
                async = true,
              },
            },
          },
        },
        opts_extend = { "sources.default" },
      },
    },
  },
}
