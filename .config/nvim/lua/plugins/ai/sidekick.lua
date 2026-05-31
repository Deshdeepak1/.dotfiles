-- NOTE: enabling requires `copilot` added to vim.lsp.enable() in config/lsp.lua
-- and a lsp/copilot.lua config file

---@module "lazy"
---@type LazySpec
return {
  {
    "folke/sidekick.nvim",
    enabled = false,
    -- cond = false,
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
    },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {},
  },
}
