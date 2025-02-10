set fish_greeting
set fish_cursor_unknown block

set -x PATH  ~/.local/scripts ~/.local/bin $PATH

export EDITOR="nvim"
export VISUAL="nvim"

# Dot files management
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
abbr dotcommit 'dotfiles commit -m "Update $(date)"'
abbr dv "GIT_DIR=~/.dotfiles $EDITOR"

function reload
    source ~/.config/fish/config.fish
    echo "Config reloaded"
end

function check_italics
    echo -e "\e[3mThis is italic text\e[0m"
    echo -e "\e[3;34mThis is blue italic text\e[0m"
    echo -e "\e[1;3;31mThis is red bold italic text\e[0m"
end

function check_undercurl
    echo -e "\e[4:3mThis text has an undercurl\e[0m"
    echo -e "\e[4:3;38;5;196mRed text with Red Undercurl\e[0m"
    echo -e "\e[38;5;82m\e[4:3m\e[58;5;196mGreen Text with Red Undercurl\e[0m"
end

function check_strikethrough
    echo -e "\e[9mThis text has a strikethrough\e[0m"
    echo -e "\e[9;38;5;196mRed text with Red strikethrough\e[0m"
end

function check_special_text_features
    check_italics
    check_undercurl
    check_strikethrough
end

# Abbreviations
abbr v "$EDITOR"
abbr n "$EDITOR"

# Aliases
alias ls="eza --icons --group-directories-first"
alias cat="bat"
alias jqc="jq -C | cat"

export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

zoxide init fish | source
