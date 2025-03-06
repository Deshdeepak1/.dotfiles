---@diagnostic disable: undefined-field
return {
  "folke/todo-comments.nvim",
  -- cond = false,
  event = "VeryLazy",
  keys = {
    {
      "<leader>ft",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo",
    },
    {
      "<leader>fT",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "TodoNext",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "TodoPrev",
    },
  },
  opts = {},
}
