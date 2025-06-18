---@module "lazy"
---@type LazySpec
return {
  "m4xshen/hardtime.nvim",
  cond = vim.env.HARDTIME == "ENABLED",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {},
}
