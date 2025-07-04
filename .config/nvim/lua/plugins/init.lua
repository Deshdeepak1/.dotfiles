---@module "lazy"
---@type LazySpec
return {
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },

  { import = "plugins.utils" },
  { import = "plugins.ui" },
  { import = "plugins.keys" },
  { import = "plugins.git" },
  { import = "plugins.cp" },
  { import = "plugins.notes" },
}
