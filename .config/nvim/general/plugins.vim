call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'neoclide/coc.nvim'
Plug 'preservim/nerdcommenter'
Plug 'voldikss/vim-floaterm'
Plug 'liuchengxu/vim-which-key'
Plug 'mhinz/vim-startify'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mattn/emmet-vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/rainbow_parentheses.vim'

Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope'

" Git:
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'

" Airline:
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" FZF:
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Telescope:
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Themes:
Plug 'gruvbox-community/gruvbox'
Plug 'joshdick/onedark.vim'

call plug#end()

source ~/.config/nvim/plug-config/vim-which-key.vim
source ~/.config/nvim/plug-config/coc.vim
source ~/.config/nvim/plug-config/sneak.vim
source ~/.config/nvim/plug-config/emmet.vim
source ~/.config/nvim/plug-config/startify.vim
source ~/.config/nvim/plug-config/floaterm.vim
source ~/.config/nvim/plug-config/telescope.vim
source ~/.config/nvim/plug-config/fzf.vim
source ~/.config/nvim/plug-config/rainbow.vim
source ~/.config/nvim/plug-config/signify.vim
source ~/.config/nvim/plug-config/quickscope.vim

" Colorizer:
"luafile ~/.config/nvim/lua/plug-colorizer.lua
" or
lua require'plug-colorizer'
":ColorizerAttachToBuffer -To use in other files

" Gruvbox
colorscheme gruvbox
highlight Normal ctermbg=None guibg=None

" Onedark
"colorscheme onedark
"source ~/.config/nvim/themes/onedark.vim

"Airline
source ~/.config/nvim/themes/airline.vim
