""" General Settings
scriptencoding utf-8
set encoding=utf-8
set nocompatible
set number
set relativenumber
set numberwidth=2

set shiftwidth=0 " Takes from tabstop
set tabstop=4
set softtabstop=-1 " Takes from shiftwidth
set expandtab
set smarttab
set smartindent
set preserveindent
set copyindent

set mouse=a
set clipboard=unnamedplus
set ruler
set nowrap
set linebreak
set nofoldenable
set undodir=~/.local/share/vim/undo
set undofile
set ignorecase
set incsearch
set scrolloff=8
set updatetime=100
set timeout
set timeoutlen=200
set ttyfast
set laststatus=2
set cursorline
set pumheight=10
set conceallevel=2
set concealcursor=c
set virtualedit=block
set noswapfile
set fileencoding=utf-8
set completeopt=menuone,noselect
set showmode
set exrc
set showcmd

" Whitespaces
set listchars=tab:»·,trail:·,space:·
" set list

" Autocompletion :find
set path+=**
set wildmenu
set wildmode=full

" Fix splitting
set splitright
set splitbelow

" Backup settings
set nobackup
set nowritebackup
set backupdir=~/.local/share/vim/backup

" Whichwrap settings
set whichwrap+=l,h,<,>,[,]
set shortmess+=c

" Cursor
let &t_ti.="\e[0 q"
let &t_SI.="\e[6 q"
let &t_EI.="\e[0 q"
let &t_te.="\e[0 q"

" Leader Key
let mapleader=" "

""" Key Mappings
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>Q :quitall!<CR>
nnoremap <leader>S :source %<CR>

" Number Toggle
nnoremap <leader>tl :set number!<CR>

" Relative Number Toggle
nnoremap <leader>tL :set relativenumber!<CR>

" Wrap Toggle
nnoremap <leader>tw :set wrap!<CR>

" Spell Toggle
nnoremap <leader>ts :set spell!<CR>

" Conceallevel Toggle
function! ToggleConcealLevel()
  if &conceallevel == 0
    let &conceallevel = 2
  else
    let &conceallevel = 0
  endif
  echo "ConcealLevel=" . &conceallevel
endfunction

nnoremap <leader>tc :call ToggleConcealLevel()<CR>

" Toggle Copy Mode
let g:copy_mode = 0
function! ToggleCopyMode()
  if g:copy_mode
    set mouse=a
    set relativenumber
    set number
    " set list
    let g:copy_mode = 0
  else
    set mouse=
    set norelativenumber
    set nonumber
    set nolist
    let g:copy_mode = 1
  endif
  echo "CopyMode=" . g:copy_mode
endfunction

command! ToggleCopyMode call ToggleCopyMode()
nnoremap <leader>tC :ToggleCopyMode<CR>


" Visual mode search
xnoremap g/ <Esc>/\%V

" Escape Remap
inoremap jk <ESC>
inoremap kj <ESC>
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" Center Screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Resize Splits
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>

" Buffer Navigation
nnoremap <leader>bb :e #<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

" Sed-like Substitutions
nnoremap <M-s> :%s///gI<Left><Left><Left><Left>
vnoremap <M-s> :s///gI<Left><Left><Left><Left>
nnoremap <C-s> :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Indentation
vnoremap > >gv
vnoremap < <gv

" Paste Behavior
xnoremap <leader>p "_dP
nnoremap cp "+
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Join Lines Without Cursor Movement
nnoremap J mzJ`z

" Move Lines Up and Down
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" New Lines
nnoremap ]<leader> :call append(line("."), repeat([""], v:count1))<CR>
nnoremap [<leader> :call append(line(".")-1, repeat([""], v:count1))<CR>

" Netrw
nnoremap <leader>E :20Lexplore!<CR>

" Open URL
nnoremap gx :silent !xdg-open "<cfile>"<CR>
nnoremap <leader>x :silent !nsxiv-url "<cfile>"<CR>



""" Colorscheme
try
    colorscheme catppuccin_mocha
    set termguicolors
    syntax on
    hi Normal guibg=NONE ctermbg=NONE
catch
    syntax on
endtry
