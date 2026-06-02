---@module "lazy"
---@type LazySpec
return {
  {
    "folke/sidekick.nvim",
    cond = function() return vim.env.AI_SIDEKICK ~= "0" end,
    -- cond = false,
    event = "InsertEnter",
    cmd = { "Sidekick" },
    dependencies = {
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "zbirenbaum/copilot.lua",
    },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {
      nes = {
        enabled = true,
        debounce = 10,
      },
      cli = {
        win = {
          layout = "right",
          split = { width = 85 },
        },
        mux = {
          enabled = true,
          backend = "tmux",
        },
        tools = {
          claude = {},
          antigravity = {
            cmd = { "agy" },
            is_proc = "\\<agy\\>",
            url = "https://antigravity.google/docs/cli-overview",
            resume = { "--continue" },
            continue = { "--continue" },
            format = function(text)
              require("sidekick.text").transform(text, function(str)
                return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
              end, "SidekickLocFile")
            end,
          },
          copilot = {},
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then return "<tab>" end
        end,
        expr = true,
        desc = "NES: Goto/Apply Next Edit Suggestion",
      },
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
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Claude",
      },
      {
        "<leader>ag",
        function() require("sidekick.cli").toggle({ name = "antigravity", focus = true }) end,
        desc = "Sidekick Antigravity",
      },
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
      {
        "<leader>ao",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Copilot",
      },
      -- NES
      { "<leader>an", function() require("sidekick.nes").update() end, desc = "NES Update" },
      { "<leader>ax", function() require("sidekick.nes").clear() end, desc = "NES Clear" },
      { "<leader>aN", function() require("sidekick.nes").toggle() end, desc = "NES Toggle" },
    },
  },
}
