---@module "lazy"
---@type LazySpec
return {
  {
    "olimorris/codecompanion.nvim",
    enabled = vim.env.AI_CODECOMPANION == "1",
    -- cond = false,
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
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {})
        end,
        claude = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = { default = "claude-sonnet-4-5" },
            },
          })
        end,
        antigravity = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = { default = "gemini-2.0-flash-001" },
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = vim.env.AI_AGENT or "copilot" },
        inline = { adapter = vim.env.AI_AGENT or "copilot" },
        agent = { adapter = vim.env.AI_AGENT or "copilot" },
      },
    },
  },
}
