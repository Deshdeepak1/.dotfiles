---@module "lazy"
---@type LazySpec
return {
  "glacambre/firenvim",
  -- cond = false,

  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  build = ":call firenvim#install(0)",
  config = function()
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = { "github.com_*.txt" },
      command = "set filetype=markdown",
    })
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = { "leetcode.com_*.txt", "www.learning.algozenith.com_*.c" },
      command = "set filetype=cpp",
    })
    vim.g.firenvim_config.localSettings[".*"] = { takeover = "never" }
    vim.g.firenvim_config = {
      localSettings = {
        [".*"] = {
          takeover = "never",
          cmdline = "neovim",
        },
      },
    }
  end,
}
