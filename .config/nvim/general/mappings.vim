let mapleader=" "

" Split Open:
nnoremap <leader>h :split<Space>
nnoremap <leader>v :vsplit<Space>

" Tab Open:
nnoremap <leader>t :tabnew<Space>

" Split Navigations:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replacing Esc:
inoremap jk <Esc>
inoremap kj <Esc>

" Ends:
noremap gl $
noremap gh 0
noremap gb G

" Replace
nnoremap <leader>s :%s//gI<Left><Left><Left>

