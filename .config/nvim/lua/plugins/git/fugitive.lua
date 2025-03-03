return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  dependencies = { "tpope/vim-rhubarb" },
  cond = function()
    local is_git = vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end,
  -- cond = false,
  keys = {
    { "<leader>gA", "<cmd>G add .<cr>", desc = "AddCDir", silent = false },
    { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Browse", silent = false },
    { "<leader>gC", ":G checkout ", desc = "Checkout", silent = false },
    { "<leader>gD", "<cmd>G diff<cr>", desc = "Diff", silent = false },
    { "<leader>gF", ":G add ", desc = "CustAdd", silent = false },
    { "<leader>gP", "<cmd>G pull<cr>", desc = "Pull", silent = false },
    { "<leader>gR", "<cmd>GDelete<cr>", desc = "Remove", silent = false },
    { "<leader>ga", "<cmd>Gw<cr>", desc = "Add", silent = false },
    { "<leader>gb", "<cmd>G branch<cr>", desc = "branches", silent = false },
    { "<leader>gbb", "<cmd>G blame<cr>", desc = "Blame", silent = false },
    { "<leader>gc", "<cmd>G commit<cr>", desc = "Commit", silent = false },
    { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "DiffSplit", silent = false },
    { "<leader>gf", "<cmd>G fetch<cr>", desc = "Fetch", silent = false },
    { "<leader>gl", "<cmd>Gclog<cr>", desc = "Log", silent = false },
    { "<leader>gp", "<cmd>G push<cr>", desc = "Push", silent = false },
    { "<leader>gr", ":GMove ", desc = "Move/Rename", silent = false },
    { "<leader>gs", "<cmd>G<cr>", desc = "Status", silent = false },
  },
}
