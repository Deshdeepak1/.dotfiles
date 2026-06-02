vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 200, on_macro = true }) end,
})

vim.api.nvim_create_autocmd("FileType", {
  command = "set formatoptions-=cro",
})

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "LSP Info" })
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("tabnew " .. vim.lsp.log.get_filename())
end, { desc = "LSP Log" })
vim.api.nvim_create_user_command("LspRestart", function(a)
  vim.cmd("lsp restart " .. a.args)
end, { nargs = "?", desc = "LSP Restart" })
vim.api.nvim_create_user_command("LspStop", function(a)
  vim.cmd("lsp stop " .. a.args)
end, { nargs = "?", desc = "LSP Stop" })
vim.api.nvim_create_user_command("LspStart", function(a)
  vim.cmd("lsp enable " .. a.args)
end, { nargs = "?", desc = "LSP Start" })

vim.api.nvim_create_augroup("filetype_glsl", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "filetype_glsl",
  pattern = { "*.vs", "*.fs" },
  command = "set filetype=glsl",
})
