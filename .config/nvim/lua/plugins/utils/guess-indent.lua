---@module "lazy"
---@type LazySpec
return {
  {
    "nmac427/guess-indent.nvim",
    -- cond = false,
    -- event = "VeryLazy",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
