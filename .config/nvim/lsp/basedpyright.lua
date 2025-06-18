---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        inlayHints = {},
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        diagnosticSeverityOverrides = {},
      },
    },
  },
}
