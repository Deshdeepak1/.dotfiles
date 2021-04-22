" Change these if you want
"let g:signify_sign_add               = '+'
"let g:signify_sign_delete            = '_'
"let g:signify_sign_delete_first_line = '‾'
"let g:signify_sign_change            = '~'

"let g:signify_disable_by_default = 1

" I find the numbers disctracting
let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 1


" Jump though hunks
"nmap <leader>gj <plug>(signify-next-hunk)
"nmap <leader>gk <plug>(signify-prev-hunk)
"nmap <leader>gJ 9999<leader>gJ
"nmap <leader>gK 9999<leader>gk

nnoremap <leader>gF :G add<Space>
nnoremap <leader>gm :GMove<Space>
nnoremap <leader>gb :G branch<Space>

" g is for git
let g:which_key_map.g = {
    \ 'name' : '+Git',
    \ 'h' : [':SignifyToggleHighlight', 'Highlight'],
    \ 't' : [':SignifyToggle', 'Toggle'],
    \ 's' : [':G', 'Status'],
    \ 'd' : [':Gdiffsplit', 'DiffSplit'],
    \ 'D' : [':G diff', 'Diff'],
    \ 'F' : 'CustAdd',
    \ 'a' : [':Gw', 'Add'],
    \ 'A' : [':G add .', 'AddCDir'],
    \ 'r' : [':GDelete', 'Remove'],
    \ 'R' : [':GRename', 'Rename'],
    \ 'm' : 'Move',
    \ 'c' : [':G commit', 'Commit'],
    \ 'p' : [':G push', 'Push'],
    \ 'P' : [':G pull', 'Pull'],
    \ 'f' : [':G fetch', 'Fetch'],
    \ 'l' : [':Gclog', 'Log'],
    \ 'b' : 'Branch',
    \ 'C' : [':GCheckout', 'Checkout'],
    \ 'bb' : [':G blame', 'Blame'],
    \ 'B' : [':GBrowse', 'Browse'],
    \ 'cc' : [':GV!', 'Commits'],
    \ 'CC' : [':GV', 'AllCommits'],
  \ }

" If you like colors instead
"highlight SignifySignAdd                  ctermbg=green                guibg=#00ff00
"highlight SignifySignDelete ctermfg=black ctermbg=red    guifg=#ffffff guibg=#ff0000
"highlight SignifySignChange ctermfg=black ctermbg=yellow guifg=#000000 guibg=#ffff00

"highlight SignifySignAdd    ctermfg=green  guifg=#00ff00 cterm=NONE gui=NONE
"highlight SignifySignDelete ctermfg=red    guifg=#ff0000 cterm=NONE gui=NONE
"highlight SignifySignChange ctermfg=yellow guifg=#ffff00 cterm=NONE gui=NONE
