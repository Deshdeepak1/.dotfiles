set fish_greeting
set fish_cursor_unknown block


set -x PATH  ~/.local/scripts ~/.local/bin $PATH

export EDITOR="nvim"
export VISUAL="nvim"

# Dot files management
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
abbr dv "GIT_DIR=~/.dotfiles $EDITOR"

# Abbreviations
abbr v "$EDITOR"
abbr n "$EDITOR"

# Aliases
alias ls="exa --icons --group-directories-first"
alias cat="bat"
alias jqc="jq -C | cat"

export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

zoxide init fish | source
