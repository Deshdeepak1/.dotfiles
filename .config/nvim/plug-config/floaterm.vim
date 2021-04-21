let g:floaterm_keymap_toggle = '<F7>'
let g:floaterm_keymap_next   = '<F8>'
let g:floaterm_keymap_prev   = '<F9>'
let g:floaterm_keymap_new    = '<F10>'
"let g:floaterm_keymap_kill   = '<F12>'

" Floaterm
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
let g:floaterm_opener='tabe'

let g:which_key_map['t'] = [':FloatermToggle', 'Terminal']

let g:which_key_map.f = {
      \ 'name' : '+Floaterm' ,
      \ 'f' : [':FloatermNew fzf'                               , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'                           , 'git'],
      \ 'd' : [':FloatermNew lazydocker'                        , 'docker'],
      \ 'p' : [':FloatermNew python'                            , 'python'],
      \ 'r' : [':FloatermNew ranger'                            , 'ranger'],
      \ 't' : [':FloatermToggle'                                , 'toggle'],
      \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
      \ }

let g:which_key_map.r = {
    \ 'name' : 'Run',
    \ 'p' : [':FloatermNew --autoclose=0 python %'  , 'python'],
  \ }
