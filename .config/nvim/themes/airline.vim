
" enable powerline fonts
let g:airline_powerline_fonts = 1
"let g:airline_left_sep = ''
"let g:airline_right_sep = ''
let g:airline_detect_modified=1

" Switch to your current theme
let g:airline_theme = 'bubblegum'

" We don't need to see things like -- INSERT -- anymore
set noshowmode

" enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_splits = 0


let g:airline#extensions#tabline#buffer_idx_mode = 1

" a is for airline-tabline
let g:which_key_map.a = {
    \ 'name' : '+Airline',
    \ '1' : ['<Plug>AirlineSelectTab1'  , 'Tab1'],
    \ '2' : ['<Plug>AirlineSelectTab2'  , 'Tab2'],
    \ '3' : ['<Plug>AirlineSelectTab3'  , 'Tab3'],
    \ '4' : ['<Plug>AirlineSelectTab4'  , 'Tab4'],
    \ '5' : ['<Plug>AirlineSelectTab5'  , 'Tab5'],
    \ '6' : ['<Plug>AirlineSelectTab6'  , 'Tab6'],
    \ '7' : ['<Plug>AirlineSelectTab7'  , 'Tab7'],
    \ '8' : ['<Plug>AirlineSelectTab8'  , 'Tab8'],
    \ '9' : ['<Plug>AirlineSelectTab9'  , 'Tab9'],
    \ 'n' : ['<Plug>AirlineSelectNextTab'  , 'Next'],
    \ 'p' : ['<Plug>AirlineSelectPrevTab'  , 'Prev'],
    \ 't' : ['AirlineToggle'  , 'Toggle'],
  \ }
