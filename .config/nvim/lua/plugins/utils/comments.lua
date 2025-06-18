---@module "lazy"
---@type LazySpec
return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    -- cond = false,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      -- Native commenting
      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  {
    "numToStr/Comment.nvim",
    -- event = "VeryLazy",
    -- cond = false,
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "gc" },
      { "gb" },
      { "gb", mode = "x" },
    },
    -- opts = {},
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
}
