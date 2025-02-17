vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200, on_macro = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  command = "set formatoptions-=cro",
})

vim.api.nvim_create_augroup("filetype_glsl", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "filetype_glsl",
  pattern = { "*.vs", "*.fs" },
  command = "set filetype=glsl",
})
