-- vim.cmd [[
-- " enable powerline fonts
vim.g[ 'airline_powerline_fonts' ] = 1
-- "let g:airline_left_sep = ''
-- "let g:airline_right_sep = ''
vim.g[ 'airline_detect_modified' ] = 1

-- " Switch to your current theme
vim.g[ 'airline_theme' ] = 'deus'


-- " enable tabline
vim.g[ 'airline#extensions#tabline#enabled' ] = 1
vim.g[ 'airline#extensions#tabline#show_buffers' ] = 0
vim.g[ 'airline#extensions#tabline#show_tabs' ] = 1
vim.g[ 'airline#extensions#tabline#show_tab_count' ] = 0
vim.g[ 'airline#extensions#tabline#show_tab_nr' ] = 1
vim.g[ 'airline#extensions#tabline#tab_nr_type' ] = 1
vim.g[ 'airline#extensions#tabline#show_tab_type' ] = 0
vim.g[ 'airline#extensions#tabline#tab_min_count' ] = 2
vim.g[ 'airline#extensions#tabline#formatter' ] = 'unique_tail'
vim.g[ 'airline#extensions#tabline#show_splits' ] = 0


vim.g[ 'airline#extensions#tabline#buffer_idx_mode' ] = 1

-- Nvim-lsp
vim.g[ 'airline#extensions#nvimlsp#enabled' ] = 1
vim.g[ 'airline#extensions#nvimlsp#error_symbol' ] = ' '
vim.g[ 'airline#extensions#nvimlsp#warning_symbol' ] = ' '
-- ]]

-- Change section order
vim.g[ 'airline#extensions#default#layout' ] = {
     { 'a', 'b', 'error', 'warning', 'c'},
     { 'x', 'y', 'z' }
}
-- Fix color
vim.g[ 'airline#extensions#default#section_use_groupitems' ] = 0
