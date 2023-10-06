return {
    {
        "mfussenegger/nvim-dap",
        cmd = { "DapContinue", "DapToggleBreakpoint" },
        -- ft = { "python", },
        keys = { "<F5>", "<F8>", "<F9>", "<F10>" },
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
            vim.keymap.set("n", "<F5>", ":DapContinue<cr>", { silent = false, desc = "DapContinue" })
            vim.keymap.set("n", "<F8>", ":DapStepInto<cr>", { silent = false, desc = "DapStepInto" })
            vim.keymap.set("n", "<F9>", ":DapStepOut<cr>", { silent = false, desc = "DapStepOut" })
            vim.keymap.set("n", "<F1O>", ":DapStepOver<cr>", { silent = false, desc = "DapStepOver" })
        end,
    }
}
