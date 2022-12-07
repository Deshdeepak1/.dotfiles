local ok, indentline = pcall(require, "indent_blankline")
if not ok then
    return
end
indentline.setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false,
    use_treesitter = true,
})

-- vim.cmd [[highlight IndentBlanklineContextChar guifg=#00FF00 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextChar guifg=lightpink gui=nocombine]]
