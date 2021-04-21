let g:startify_padding_left = 50

let g:startify_custom_header = startify#center([
  \ '    / | / /__  ____ _   __(_)___ ___ ',
  \ '   /  |/ / _ \/ __ \ | / / / __ `__ \',
  \ '  / /|  /  __/ /_/ / |/ / / / / / / /',
  \ ' /_/ |_/\___/\____/|___/_/_/ /_/ /_/ '])

let g:startify_files_number = 5
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_enable_special = 1

let g:startify_lists = [
          \ { 'type': 'files',     'header': startify#pad(['Files']) },
          \ { 'type': 'dir',       'header': startify#pad(['Current Directory '. getcwd()]) },
          \ { 'type': 'sessions',  'header': startify#pad(['Sessions']) },
          \ { 'type': 'bookmarks', 'header': startify#pad(['Bookmarks']) },
          \ ]

let g:startify_bookmarks = [
            \ {'n': '~/.config/nvim'},
            \ {'l': '~/labs'},
            \ {'g': '~/.config/nvim/general'},
            \ {'p': '~/.config/nvim/plug-config'}
            \]

" S is for Startify
let g:which_key_map.S = {
    \ 'name'    : '+Startify',
    \ 's' : [':SSave'   , 'Save'],
    \ 'q' : [':SClose'  , 'Close'],
    \ 'l' : [':SLoad'   , 'Load'],
    \ 'd' : [':SDelete' , 'Delete'],
    \ 'S' : [':Startify', 'Startify'],
    \ 'D' : [':StartifyDebug', 'StartifyDebug'],
  \ }

autocmd User StartifyReady nnoremap d :call DVim()<CR>
autocmd User StartifyBufferOpened nnoremap d <Nop>

let g:startify_custom_footer = startify#pad(['[d]  DVim'])
