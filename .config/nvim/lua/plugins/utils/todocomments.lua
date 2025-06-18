---@module "lazy"
---@type LazySpec
return {
  "folke/todo-comments.nvim",
  -- cond = false,
  event = "VeryLazy",
  keys = {
    {
      "<leader>ft",
      function()
        ---@module 'snacks'
        ---@diagnostic disable-next-line: undefined-field
        Snacks.picker.todo_comments()
      end,
      desc = "Todo",
    },
    {
      "<leader>fT",
      function()
        ---@diagnostic disable-next-line: undefined-field
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "TodoNext",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "TodoPrev",
    },
  },
  opts = {
    signs = false,
  },
}
