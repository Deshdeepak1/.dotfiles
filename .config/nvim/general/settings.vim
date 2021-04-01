" CONFIGURE LINE NUMS:
set number
set relativenumber
set numberwidth=2

" TAB:
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" VIOFF
set nocompatible

" ARROWS OFF:
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

syntax enable
set mouse=a
set smartindent
set cindent
set ruler
set nohlsearch
set hidden
set noerrorbells
set nowrap
set undodir=~/.config/nvim/undo
set undofile
set incsearch
set scrolloff=8
set termguicolors
set updatetime=300
set cursorline

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Autocompletion
set wildmode=longest,list,full

" Fix splitting
set splitright splitbelow


" CHAR LIMIT:
highlight ColorColumn ctermbg=gray
"" filetype detect
"" if &filetype=='python'
""     set cc=79
"" endif
autocmd BufNewFile,BufRead *.py set cc=79

" Remove trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" BACKUPDIR:
set backupdir=~/.local/share/nvim/backup
