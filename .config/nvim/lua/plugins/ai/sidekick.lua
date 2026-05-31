---@module "lazy"
---@type LazySpec
return {
  {
    "folke/sidekick.nvim",
    -- enabled = false,
    -- cond = false,
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects", -- for {function}/{class} context vars
    },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {
      nes = {
        enabled = true,
      },
      cli = {
        -- layout for the CLI terminal window
        win = {
          layout = "right",
          split = { width = 85 },
        },
        -- mux: set backend = "tmux" or "zellij" for persistent sessions
        mux = {
          enabled = false,
        },
        -- Pre-configured CLI tools (claude/gemini/copilot already built-in)
        -- Override per-tool defaults here if needed
        tools = {
          claude = {},
          gemini = {},
          copilot = {},
        },
      },
    },
    keys = {
      -- NES (Next Edit Suggestions)
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then return "<tab>" end
        end,
        expr = true,
        desc = "NES: Goto/Apply Next Edit Suggestion",
      },
      -- CLI Terminal
      { "<leader>as", function() require("sidekick.cli").select() end, desc = "Sidekick Select CLI" },
      { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Sidekick Detach CLI" },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Sidekick Send This",
      },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Sidekick Send File" },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Sidekick Send Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Quick-open specific CLIs
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Claude",
      },
      {
        "<leader>ag",
        function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end,
        desc = "Sidekick Gemini",
      },
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
    },
  },
}
