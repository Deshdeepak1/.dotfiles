---@module "lazy"
---@type LazySpec
local ai = require("config.ai")

return {
  {
    "yetone/avante.nvim",
    cond = ai.ui == "avante",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      "folke/snacks.nvim",
    },
    ---@module "avante"
    ---@type avante.Config
    opts = {
      provider = ai.name("avante"),
      acp_providers = {
        ["claude-code"] = {
          env = { ACP_PERMISSION_MODE = "default" },
        },
        ["copilot-acp"] = {
          command = "copilot",
          args = { "--acp", "--stdio" },
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
    },
  },
}
