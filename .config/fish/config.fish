# Programs Recommended:
# fish, vim/nvim/nvim-nightly, pynvim/pyvim, exa, tmux, git, screenfetch, bat, python(pip - pylint, autopep8),
# Hack font, noto-fonts-emoji, fd, fzf, lazygit, ranger, ranger_devicons, ctags, ripgrep, luarocks

# git config --global user.email "rkdeshdeepak1@gmail.com"
# git config --global user.name "Deshdeepak"
# git config --global credential.helper cache/store
set fish_greeting

# Dot files management
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
#dotfiles config status.showUntrackedFiles no
#dotfiles config --local credential.helper cache/store
#git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local core.worktree $HOME
alias dvim="env GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME vim"

# Abbreviations
abbr 	vrc  	"dvim ~/.vimrc"
abbr 	nvrc 	"dvim ~/.config/nvim/init.vim"
abbr	frc 	"dvim ~/.config/fish/config.fish"
abbr    fpac    "pacman -Slq | fzf -m --preview 'cat (pacman -Si {1} | psub) (pacman -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro sudo pacman -Sy"
abbr    fyay    "yay -Slq | fzf -m --preview 'cat (yay -Si {1} | psub) (yay -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  yay -Sy"


# Aliases
alias ls="exa --icons"
alias cat="bat"

# screenfetch

export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"

# Functions
