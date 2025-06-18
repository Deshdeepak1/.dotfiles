---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      format = {
        enable = false,
        -- Put format options here
        -- NOTE: the value should be String!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      semantic = {
        enable = true, -- Enable semantic tokens for better syntax highlighting
      },
      diagnostics = {
        globals = { "vim", "Snacks" },
        disable = { "lowercase-global" },
        severity = {
          ["unused-local"] = "Hint",
          ["redefined-local"] = "Warning",
        },
      },
    },
  },
}
