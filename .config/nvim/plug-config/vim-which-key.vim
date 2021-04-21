" Map leader to which_key
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" Define a separator
let g:which_key_sep = '→'

set timeoutlen=300
let g:which_key_exit = "\<Space>"
let g:which_key_use_floating_win = 0

" Create map to add keys to
let g:which_key_map =  {}

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Single Mappings:
let g:which_key_map['e'] = [ ':CocCommand explorer', 'Explorer']
let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle', 'Comment']
let g:which_key_map['s'] = [ ':update', 'Save']
let g:which_key_map['q'] = [ ':quit', 'Quit']
let g:which_key_map['qq'] = [ ':quitall', 'QuitAll']
let g:which_key_map['ss'] = [ ':source %', 'Source']
let g:which_key_map['Q'] = [ ':quitall!', 'ForceQuit']
let g:which_key_map['o'] = [ ':only', 'OnlyWindow']
let g:which_key_map['H'] = [ ':vert help', 'Help']
let g:which_key_map['h'] = 'HSplit'
let g:which_key_map['v'] = 'VSplit'
let g:which_key_map['n'] = 'NewTab'

" Double Mappings:
let g:which_key_map['sq'] = [ ':wq', 'Save&Quit']

" c is for comment
let g:which_key_map.c = {
    \ 'name' : '+Comment',
  \ }

" C is for Coc
let g:which_key_map.C = {
    \ 'name' : '+Coc',
  \ }


" b is for buffer
let g:which_key_map.b = {
    \ 'name' : '+Buffer',
    \ 'n' : [':bnext', 'Next'],
    \ 'p' : [':bprevious', 'Previous'],
  \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
