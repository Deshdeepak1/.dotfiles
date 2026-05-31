---@module "lazy"
---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    -- cond = false,
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
    "giuxtaposition/blink-cmp-copilot",
    -- cond = false,
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
                module = "blink-cmp-copilot",
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
