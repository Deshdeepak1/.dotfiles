---@module "lazy"
---@type LazySpec
local ai = require("config.ai")

return {
  {
    "olimorris/codecompanion.nvim",
    cond = ai.ui == "codecompanion",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Chat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "Inline", mode = { "n", "v" } },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = { "v" } },
      { "<leader>al", "<cmd>CodeCompanionCLI<cr>", desc = "CLI" },
      {
        "<leader>at",
        function() require("codecompanion").cli("#{this}", { focus = false }) end,
        mode = { "n", "x" },
        desc = "CLI Send This",
      },
      {
        "<leader>ap",
        function() require("codecompanion").cli({ prompt = true }) end,
        mode = { "n", "x" },
        desc = "CLI Prompt",
      },
      {
        "<leader>ad",
        function() require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true }) end,
        desc = "CLI Fix Diagnostics",
      },
    },
    opts = {
      interactions = {
        chat = { adapter = ai.name("codecompanion") },
        inline = { adapter = "copilot" },
        cli = {
          agent = ai.name("cli"),
          agents = {
            claude = {
              cmd = "claude",
              args = { "--ide" },
              description = "Claude Code CLI",
              provider = "terminal",
            },
            copilot = {
              cmd = "copilot",
              args = {},
              description = "GitHub Copilot CLI",
              provider = "terminal",
            },
            codex = {
              cmd = "codex",
              args = {},
              description = "Codex CLI",
              provider = "terminal",
            },
            opencode = {
              cmd = "opencode",
              args = {},
              description = "OpenCode CLI",
              provider = "terminal",
            },
            antigravity = {
              cmd = "agy",
              args = {},
              description = "Antigravity CLI",
              provider = "terminal",
            },
          },
        },
      },
      display = {
        diff = { threshold_for_chat = 0 },
      },
    },
  },
}
