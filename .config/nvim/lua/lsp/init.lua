local st_ok, lspconfig = pcall(require, "lspconfig")
if not st_ok then
    return
end

require("lsp.lsp-installer")
require("lsp.handlers").setup()
