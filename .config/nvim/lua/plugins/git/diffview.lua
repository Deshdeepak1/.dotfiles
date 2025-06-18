---@module "lazy"
---@type LazySpec
return {
  "sindrets/diffview.nvim",
  -- event = "VeryLazy",
  dependencies = {},
  cond = function()
    local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end,
  -- cond = false,
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
    "DiffviewRefresh",
  },
  keys = {
    { "<leader>vo", "<cmd>DiffviewOpen<cr>", desc = "Open", silent = false },
    { "<leader>vO", ":DiffviewOpen ", desc = "Open", silent = false },
    { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Close", silent = false },
    { "<leader>vf", "<cmd>DiffviewFocusFiles<cr>", desc = "FocusFiles", silent = false },
    { "<leader>vt", "<cmd>DiffviewToggleFiles<cr>", desc = "ToggleFiles", silent = false },
    { "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", desc = "FileHistory", silent = false },
    { "<leader>vH", ":DiffviewFileHistory ", desc = "History", silent = false },
    { "<leader>vh", ":DiffviewFileHistory<cr>", desc = "SelectionHistory", silent = false, mode = { "v" } },
    { "<leader>vb", "<cmd>DiffviewFileHistory<cr>", desc = "BranchHistory", silent = false },
    { "<leader>vr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh", silent = false },
  },
  opts = {
    -- enhanced_diff_hl = true,
  },
}
