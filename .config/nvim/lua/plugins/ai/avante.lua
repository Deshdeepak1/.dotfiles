---@module "lazy"
---@type LazySpec
return {
  {
    "yetone/avante.nvim",
    enabled = false,
    -- cond = false,
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module "avante"
    ---@type avante.Config
    opts = {
      provider = "copilot",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-6",
        api_key_name = "ANTHROPIC_API_KEY",
      },
    },
  },
}
