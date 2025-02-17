return {
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    cond = function()
        local is_git = vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    config = true,
  }
}
