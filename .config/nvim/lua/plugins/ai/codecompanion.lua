---@module "lazy"
---@type LazySpec
return {
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    -- cond = false,
    -- NOTE: to enable, set enabled = true. Default adapter is copilot.
    -- Switch adapter: opts.strategies.chat.adapter = "copilot" | "claude" | "gemini"
    -- Requires ANTHROPIC_API_KEY / GEMINI_API_KEY env vars for respective adapters.
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "Inline", mode = { "n", "v" } },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = { "v" } },
    },
    opts = {
      adapters = {
        copilot = function() return require("codecompanion.adapters").extend("copilot", {}) end,
        claude = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
            schema = {
              model = { default = "claude-sonnet-4-5" },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = { api_key = "GEMINI_API_KEY" },
            schema = {
              model = { default = "gemini-2.0-flash" },
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
    },
  },
}
