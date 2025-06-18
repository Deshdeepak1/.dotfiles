---@module "lazy"
---@type LazySpec
return {
  "kylechui/nvim-surround",
  -- cond = false,
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  -- event = "VeryLazy",
  keys = { "ys", "cs", "ds" },
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
  end,
}
