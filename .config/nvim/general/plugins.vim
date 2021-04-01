call plug#begin('~/.local/share/nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'neoclide/coc.nvim'
Plug 'preservim/nerdcommenter'

call plug#end()

" Gruvbox
colorscheme gruvbox

source ~/.config/nvim/plug-config/coc.vim
ab cocv ~/.config/nvim/plug-config/coc.vim
