return {
  "folke/trouble.nvim",
  -- cond = false,
  -- optional = true,
  -- lazy = false,
  event = "VeryLazy",
  cmd = "Trouble",
  keys = {
    {
      "<leader>Td",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>TD",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics",
    },
    {
      "<leader>Ts",
      "<cmd>Trouble lsp_document_symbols toggle win.position=right<cr>",
      desc = "Symbols",
    },
    {
      "<leader>Tr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "References",
    },
    {
      "<leader>Ti",
      "<cmd>Trouble lsp_incoming_calls toggle<cr>",
      desc = "Incoming Calls",
    },
    {
      "<leader>To",
      "<cmd>Trouble lsp_outgoing_calls toggle<cr>",
      desc = "Outgoing Calls",
    },
    {
      "<leader>Tl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ...",
    },
    {
      "<leader>Tq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List",
    },
  },
  specs = {
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end,
    },
  },
  opts = {},
}
