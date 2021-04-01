# Programs Required: fish, vim/nvim, pynvim/pyvim, exa, tmux, git, screenfetch, bat

set fish_greeting  

# Abbreviations
abbr 	vrc  	"vim ~/.vimrc"
abbr 	nvrc 	"vim ~/.config/nvim/init.vim"
abbr	frc 	"vim ~/.config/fish/config.fish"

# Dot files management
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# Aliases
alias ls="exa --icons"
alias cat="bat"

# screenfetch

