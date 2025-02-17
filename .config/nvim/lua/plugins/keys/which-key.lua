return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
  -- config = function()
  --   local wk = require("which-key")
  --   wk.add({
  --     { "<leader>c", group = "QuickFix", silent = false },
  --     { "<leader>b", group = "Buffer" },
  --     { "<leader>f", group = "Telescope" },
  --     { "<leader>h", desc = "Hunk", silent = false },
  --     { "<leader>d", group = "Dap", silent = false },
  --     { "<leader>g", group = "Git", silent = false },
  --     { "<leader>n", group = "Neorg", silent = false },
  --   })
  -- end


