---@module "lazy"
---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapToggleBreakpoint" },
    -- ft = { "python", },
    keys = {
      { "<leader>dt", ":DapTerminate<cr>", desc = "Terminate", silent = false },
      { "<leader>db", ":PBToggleBreakpoint<cr>", desc = "ToggleBreakpoint", silent = false },
      { "<leader>dB", ":PBSetConditionalBreakpoint<cr>", desc = "SetConditionalBreakpoint", silent = false },
      {
        "<leader>dl",
        function() require("persistent-breakpoints.api").load_breakpoints() end,
        desc = "LoadBreakpoints",
        silent = false,
      },
      { "<leader>dc", ":DapContinue<cr>", desc = "Continue", silent = false },
      { "<leader>dL", function() require("dap").run_last() end, desc = "RunLast", silent = false },
      { "<leader>dn", ":DapStepOver<cr>", desc = "StepOver", silent = false },
      { "<leader>do", ":DapStepOut<cr>", desc = "StepOut", silent = false },
      { "<leader>dr", function() require("dap").restart() end, desc = "Restart", silent = false },
      { "<leader>ds", ":DapStepInto<cr>", desc = "StepInto", silent = false },
      { "<leader>du", function() require("dap-view").toggle() end, desc = "ToggleUI", silent = false },
    },
    dependencies = {
      -- "rcarriga/nvim-dap-ui",
      -- "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      -- "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      {
        "igorlfs/nvim-dap-view",
        -- cond = false,
        opts = {
          winbar = {
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
            default_section = "scopes",
          },
          windows = {
            terminal = {
              -- hide = { "python" },
            },
          },
        },
      },
      {
        "Weissle/persistent-breakpoints.nvim",
        opts = {},
      },
    },
    config = function()
      local dap = require("dap")
      dap.defaults.fallback.external_terminal = {
        command = "tmux",
        args = { "split-window", "-d", "-l", "25%" },
      }
      dap.defaults.fallback.force_external_terminal = true

      -- local dapui = require("dapui")
      -- dapui.setup({})

      require("mason-nvim-dap").setup({
        handlers = {},
      })
      require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      require("nvim-dap-virtual-text").setup({
        commented = true,
        virt_text_pos = "eol", -- NOTE: inline/eol
      })

      local dap_view = require("dap-view")
      dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
      dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
      dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
      dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

      local signs = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
      }
      for name, sign in pairs(signs) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define("Dap" .. name, {
          text = sign[1],
          texthl = sign[2] or "DiagnosticInfo",
          linehl = sign[3],
          numhl = sign[3],
        })
      end

      -- dap.adapters.gdb = {
      --   type = "executable",
      --   command = "gdb",
      --   args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      -- }
      -- dap.configurations.c = {
      --   {
      --     name = "Launch",
      --     type = "gdb",
      --     request = "launch",
      --     program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      --     cwd = "${workspaceFolder}",
      --     stopAtBeginningOfMainSubprogram = false,
      --   },
      --   {
      --     name = "Select and attach to process",
      --     type = "gdb",
      --     request = "attach",
      --     program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      --     pid = function()
      --       local name = vim.fn.input("Executable name (filter): ")
      --       return require("dap.utils").pick_process({ filter = name })
      --     end,
      --     cwd = "${workspaceFolder}",
      --   },
      --   {
      --     name = "Attach to gdbserver :1234",
      --     type = "gdb",
      --     request = "attach",
      --     target = "localhost:1234",
      --     program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      --     cwd = "${workspaceFolder}",
      --   },
      -- }
      --
    end,
  },
}
