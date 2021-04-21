let mapleader=" "

"" Split Open:
nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

"" Tab Open:
nnoremap <leader>n :tabnew<Space>

" Split Navigations:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Split Resize:
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" TAB Navigations:
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> :tabprevious<CR>

" Buffer Navigations:
nnoremap <leader>bb :buffer<Space>

" Replacing Esc:
inoremap jk <Esc>
inoremap kj <Esc>

" Ends:
noremap gl $
noremap gh 0
noremap gb G

" Replace
nnoremap <A-s> :%s//gI<Left><Left><Left>

" Better Indentation:
vnoremap < <gv
vnoremap > >gv

" Easy CAPS:
" ~ - togglecase ; Letter if no selection
" u - lowercase  ; After Selection
" U - uppercase  ; After Selection
" g - use with objects/motion
" g~~/V~ - Togglecase for line

" ARROWS OFF:
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>