""" General Settings
set number
set relativenumber
set numberwidth=2

set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab

set mouse=a
set mousemoveevent
set smartindent
" set cindent
set ruler
set nowrap
set linebreak
set foldenable
set undodir=~/.local/share/nvim/undo
set undofile
set incsearch
set scrolloff=8
set termguicolors
set updatetime=100
set timeout
set timeoutlen=300
set cursorline
set signcolumn=yes:1
set pumheight=10
set conceallevel=2
set concealcursor=c
set noswapfile
set fileencoding=utf-8
set completeopt=menuone,noselect
set showmode
set exrc
set listchars=tab:<->,trail:-,nbsp:\u2423,space:\u00B7
set list

" Autocompletion
set wildmode=longest,list,full

" Splitting behavior
set splitright
set splitbelow

" Backup
set nobackup
set backupdir=~/.local/share/nvim/backup

" Key Mappings
let mapleader=" "
let maplocalleader=","  " TODO: Change as in conflict

" Save & Quit
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>Q :quitall!<CR>
nnoremap <leader>s :source %<CR>

" Wrap toggle
nnoremap <leader>w :set wrap!<CR>

" Remap ESC
inoremap jk <ESC>
inoremap kj <ESC>
nnoremap <Esc> :nohlsearch<CR>

" Center Screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Splits Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>

" Buffer Navigation
nnoremap <leader>bb :b<SPACE>
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" Sed-like Substitute
nnoremap <M-s> :%s///gI<Left><Left><Left><Left>
vnoremap <M-s> :s///gI<Left><Left><Left><Left>
nnoremap <C-s> :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Indentation
vnoremap > >gv
vnoremap < <gv

" Paste behavior
xnoremap <leader>p "_dP
nnoremap cp "+
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Join lines without cursor movement
nnoremap J mzJ`z

" Move Lines
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" New Lines
nnoremap zj :<C-u>call append(line("."), repeat([""], v:count1))<CR>
nnoremap zk :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

" Quick Fix Navigation
nnoremap <leader>cj :cprev<CR>zz
nnoremap <leader>ck :cnext<CR>zz

