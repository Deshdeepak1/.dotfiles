# when bash is interactive login shell or non-interactive but with --login : first executes /etc/profile then first of ~/.bash_profile, ~/.bash_login, ~/.profile
# --noprofile to inhibit

# when bash is interactive shell that is not login : ~/.bashrc
# --norc to inhibit
[[  "$LOCALBASHRCSOURCED" == "Y" ]] && return

LOCALBASHRCSOURCED="Y"
# echo LOCALBASHRCSOURCED

[[ $- != *i* ]] && return

[ -r $HOME/.local/share/blesh/ble.sh ] && source ~/.local/share/blesh/ble.sh --noattach

export EDITOR="nvim"
export VISUAL="nvim"

command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists eza; then
    alias ls="eza --hyperlink --icons --group-directories-first"
else
    alias ls='ls --color=auto'
fi
alias ll="ls -l"
alias la="ll -a"

[ -r $HOME/.bash_personal ] && source $HOME/.bash_personal

if command_exists bat; then
    alias cat="bat"
    export MIN_CAT="bat -n --color=always --line-range=:500"
    export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
else
    export MIN_CAT="cat -n"
fi


export FD_DEFAULT_OPTS="--exclude .git --exclude .snapshot --exclude .cache --exclude .ccache --hidden"

export FZF_DEFAULT_COMMAND="fd ${FD_DEFAULT_OPTS} --type f"


export FZF_CTRL_T_OPTS="--preview='${MIN_CAT} {}'"
export FZF_CTRL_T_COMMAND="fd ${FD_DEFAULT_OPTS} --type f"

export FZF_ALT_C_OPTS="--preview 'tree -L 2 -C {} | head -200'"
export FZF_ALT_C_COMMAND="fd ${FD_DEFAULT_OPTS} --type d"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#0C0C0C,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4 \
--bind ctrl-b:preview-half-page-up,ctrl-f:preview-half-page-down \
--bind 'ctrl-/:change-preview-window(down|hidden|)' \
"

fzf_tmux_float() {
  fzf-tmux -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}


eval "$(zoxide init bash)"
[[ ! ${BLE_VERSION-} ]] || ble-attach
