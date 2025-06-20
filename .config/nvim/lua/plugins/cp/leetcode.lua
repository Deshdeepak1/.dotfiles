local leet_arg = "lc"

---@module "lazy"
---@type LazySpec
return {
  {
    "BYT0723/leetcode.nvim",
    -- cmd = "Leet",
    lazy = leet_arg ~= vim.fn.argv()[1],
    dependencies = {
      -- "folke/snacks.nvim",
      "ilya-m32/snacks.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      arg = leet_arg,
      picker = { provider = "snacks-picker" },
      image_support = true,
      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", "using namespace std;" },
          after = "int main() {}",
        },
      },
    },
  },
}
