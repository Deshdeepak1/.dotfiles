return {
    {
        "mfussenegger/nvim-dap",
        ft = { "python", },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup({

            })
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            -- dap.listeners.before.event_terminated["dapui_config"] = function()
            --     dapui.close()
            -- end
            -- dap.listeners.before.event_exited["dapui_config"] = function()
            --     dapui.close()
            -- end
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "python",
                }
            })
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            vim.keymap.set("n", "<F5>", ":DapContinue<cr>", { silent = false })
            vim.keymap.set("n", "<F8>", ":DapStepInto<cr>", { silent = false })
            vim.keymap.set("n", "<F9>", ":DapStepOut<cr>", { silent = false })
            vim.keymap.set("n", "<F1O>", ":DapStepOver<cr>", { silent = false })

            require("which-key").register({
                d = {
                    name = "Dap",
                    b = { ":DapToggleBreakpoint<cr>", "ToggleBreakpoint" },
                    c = { ":DapContinue<cr>", "Continue" },
                    s = { ":DapStepInto<cr>", "StepInto" },
                    o = { ":DapStepOut<cr>", "StepOut" },
                    n = { ":DapStepOver<cr>", "StepOver" },
                    t = { ":DapTerminate<cr>", "Terminate" },
                    u = { dapui.toggle, "ToggleUI" },
                    e = { dapui.eval, "EvalLine" },
                    l = { dap.run_last, "RunLast" },
                },
            }, { mode = "n", prefix = "<leader>", silent = false })
        end,
    }
}
