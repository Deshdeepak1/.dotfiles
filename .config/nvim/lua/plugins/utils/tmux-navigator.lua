---@module "lazy"
---@type LazySpec
return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  cond = function()
    -- return false
    return os.getenv("TMUX") ~= nil
  end,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-w>h", "<cmd>TmuxNavigateLeft<cr>" },
    { "<c-w>j", "<cmd>TmuxNavigateDown<cr>" },
    { "<c-w>k", "<cmd>TmuxNavigateUp<cr>" },
    { "<c-w>l", "<cmd>TmuxNavigateRight<cr>" },
  },
  init = function() vim.g.tmux_navigator_no_mappings = 1 end,
}
