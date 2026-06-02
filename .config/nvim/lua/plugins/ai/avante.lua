---@module "lazy"
---@type LazySpec
return {
  {
    "yetone/avante.nvim",
    enabled = vim.env.AI_AVANTE == "1",
    -- cond = false,
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      "folke/snacks.nvim",
    },
    ---@module "avante"
    ---@type avante.Config
    opts = {
      provider = vim.env.AI_AGENT or "copilot",
      providers = {
        copilot = {},
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-5",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
        antigravity = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/openai",
          model = "gemini-2.0-flash",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
    },
  },
}
