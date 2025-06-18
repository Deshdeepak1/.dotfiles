vim.lsp.enable({
  "lua_ls",
  "basedpyright",
  "ruff",
  "clangd",
  "jsonls",
})

vim.diagnostic.config({
  underline = false,
  -- virtual_lines = {
  --   current_line = true,
  -- },
  virtual_lines = false,
  virtual_text = {
    -- current_line = true,
    severity = { max = vim.diagnostic.severity.ERROR, min = vim.diagnostic.severity.WARN },
  },
  -- virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    severity = { max = vim.diagnostic.severity.INFO, min = vim.diagnostic.severity.HINT },
  },
  -- signs = false,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
  },
})

local keymap = function(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, default_opts))
end

keymap("n", "<leader>lf", vim.diagnostic.open_float, { desc = "DiagFloat" })
keymap("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "DiagList" })
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "DiagPrev" }) -- TODO: Remove: Redundant
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "DiagNext" }) -- TODO: Remove: Redundant
keymap("n", "[w", function() vim.diagnostic.jump({ count = -1, severity = "WARN" }) end, { desc = "WarnPrev" })
keymap("n", "]w", function() vim.diagnostic.jump({ count = 1, severity = "WARN" }) end, { desc = "WarnNext" })
keymap("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = "ERROR" }) end, { desc = "ErrorPrev" })
keymap("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = "ERROR" }) end, { desc = "ErrorNext" })

keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definition" }) -- TODO: Learn C-]
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Documentation" }) -- TODO: Remove: Redundant
keymap("n", "gr", vim.lsp.buf.references, { desc = "References" }) -- TODO: Learn grr
keymap("n", "grn", vim.lsp.buf.rename, { desc = "Rename" }) -- TODO: Remove: Redundant
keymap("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" }) -- TODO: Learn grn
keymap("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" }) -- TODO: Learn gri
keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "CodeAction" }) -- TODO: Learn gra
keymap("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "TypeDef" })
keymap("n", "<leader>lF", vim.lsp.buf.format, { desc = "Format" })

keymap("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify("InlayHints=" .. tostring(vim.lsp.inlay_hint.is_enabled()), vim.log.levels.INFO, { id = "inlayhints" })
end, { desc = "InlayHintsToggle" })

keymap("n", "<leader>tv", function()
  local virtual_lines = vim.diagnostic.config().virtual_lines
  local flag = false
  if not virtual_lines then
    vim.diagnostic.config({ virtual_lines = { current_line = true } })
    flag = true
  else
    vim.diagnostic.config({ virtual_lines = false })
  end
  vim.notify("VirtualLines=" .. tostring(flag), vim.log.levels.INFO, { id = "virtaullines" })
end, { desc = "VirtualLinesToggle" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- if client.supports_method('textDocument/inlayHints') then
    --   vim.lsp.inlay_hint.enable()
    -- end

    if client.name == "ruff" then client.server_capabilities.hoverProvider = false end

    -- client.server_capabilities.documentFormattingProvider = false
    -- if client.name == "tsserver" then
    --   client.server_capabilities.documentFormattingProvider = false
    -- end
  end,
})
