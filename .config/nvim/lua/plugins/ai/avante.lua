---@module "lazy"
---@type LazySpec
return {
  {
    "yetone/avante.nvim",
    enabled = false,
    -- cond = false,
    -- NOTE: to enable, set enabled = true. Default provider is copilot.
    -- Switch provider: opts.provider = "copilot" | "claude" | "gemini"
    -- Requires ANTHROPIC_API_KEY / GEMINI_API_KEY env vars for respective providers.
    event = "VeryLazy",
    version = false, -- never pin avante to a tag
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- required for copilot provider
      "folke/snacks.nvim", -- for input UI and file picker
    },
    ---@module "avante"
    ---@type avante.Config
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          -- model selected automatically by Copilot subscription
          -- setup for copilot.lua
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-5",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 8192,
          },
        },
        gemini = {
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
