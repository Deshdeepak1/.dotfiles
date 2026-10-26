---@module "lazy"
---@type LazySpec
local ai = require("config.ai")

return {
  {
    "carlos-algms/agentic.nvim",
    cond = ai.ui == "agentic",
    opts = {
      provider = ai.name("agentic"),
    },
    keys = {
      { "<leader>aa", function() require("agentic").toggle() end, mode = { "n", "v" }, desc = "Agentic Toggle" },
      {
        "<leader>at",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Agentic Add This",
      },
      { "<leader>an", function() require("agentic").new_session() end, desc = "Agentic New Session" },
      { "<leader>ar", function() require("agentic").restore_session() end, desc = "Agentic Restore Session" },
      { "<leader>as", function() require("agentic").switch_provider() end, desc = "Agentic Switch Provider" },
      { "<leader>ad", function() require("agentic").add_current_line_diagnostics() end, desc = "Agentic Line Diagnostics" },
      { "<leader>aD", function() require("agentic").add_buffer_diagnostics() end, desc = "Agentic Buffer Diagnostics" },
      { "<leader>ax", function() require("agentic").stop_generation() end, desc = "Agentic Stop" },
      { "<leader>aX", function() require("agentic").destroy_session() end, desc = "Agentic Kill Session" },
    },
  },
}
