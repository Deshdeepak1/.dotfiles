# Programs Recommended:
# fish, vim/nvim/nvim-nightly, pynvim/pyvim, exa, tmux, git, screenfetch, bat, python(pip - pylint, autopep8),
# Hack font, noto-fonts-emoji, fd, fzf, lazygit, ranger, ranger_devicons, ctags, ripgrep, luarocks
# awesomewm, dmenu-jacob-git, termite, figlet, lolcat, cowsay, fortune, asciiquarium
# dragon-drag-and-drop, strace, screenkey

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
# abbr    vrc     "dvim ~/.vimrc"
abbr    nvrc    "cd ~/.config/nvim/ ; dvim ~/.config/nvim/init.lua"
abbr    frc     "cd ~/.config/fish/ ; dvim ~/.config/fish/config.fish"
abbr    awrc    "cd ~/.config/awesome/ ; dvim ~/.config/awesome/rc.lua"
abbr    fpac    "pacman -Slq | fzf -m --preview 'cat (pacman -Si {1} | psub) (pacman -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro sudo pacman -Sy"
abbr    fyay    "yay -Slq | fzf -m --preview 'cat (yay -Si {1} | psub) (yay -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  yay -Sy"
abbr    fparu   "paru -Slq | fzf -m --preview 'cat (paru -Si {1} | psub) (paru -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  paru -Sy"
abbr actv ". venv/bin/activate.fish"
abbr acth ". ~/hvenv/bin/activate.fish"
# abbr    fdur    "find . -iname \"*.mp4\" -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \;  | paste -sd+ | xargs -I \"{}\" python -c \"t = {} ; h = t//3600; m = (t % 3600)// 60; s = t % 60; ms =(s * 1000) % 1000;  print('%d hours %d minutes %d seconds %d miliseconds' %(h, m, s, ms))\""


# Aliases
alias ls="exa --icons --group-directories-first"
alias cat="bat"
alias tb="nc termbin.com 9999"
alias tbc="nc termbin.com 9999 | xclip -selection c"
alias jqc="jq -C | cat"
alias octave="octave -q"
alias dragon="dragon-drop"
alias aria2cc="aria2c -c -s 16 -x 16 -k 1M -j 32  --file-allocation none"
# export SHELL="sh"


export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

set  PATH $HOME/.local/share/nvim/mason/bin $HOME/.local/bin $PATH
set fish_cursor_unknown block
export EDITOR="vim"

function venv_act --description 'change directory - activate venv'
    builtin cd $param $argv
    # Check if we are inside a git directory
    if git rev-parse --show-toplevel &>/dev/null
        set venvdir "$(realpath (git rev-parse --show-toplevel))/venv"
    else
        set venvdir "./venv"
    end

    set actvate_file "$venvdir/bin/activate.fish"

    # If venv is not activated or a different venv is activated and venv exist.
    if test "$VIRTUAL_ENV" != "$venvdir" -a -f "$actvate_file"
        . "$actvate_file"
    # If venv activated but the current (git) dir has no venv.
    # else if not test -z "$VIRTUAL_ENV" -o -e "$gitdir/.venv"
    #     deactivate
    end
end



# Time Fixing
# Start ntpd service
# timedatectl set-ntp true

# export TERM="xterm-256color" # same with no export : set by termite
# export TERM="screen-256color"
# export TERM="tmux-256color"

#fortune | cowsay | lolcat
# fm6000 -r -m 5 -g 5 -c random

function backup --argument filename
    cp $filename $filename.bak
end

function fdur
    # find $argv -iname "*.mp4" -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \;  | paste -sd+ | xargs -I "{}" python -c "t = {} ; h = t//3600; m = (t % 3600)// 60; s = t % 60; ms =(s * 1000) % 1000;  print('%d hours %d minutes %d seconds %d miliseconds' %(h, m, s, ms))"
    set t (find $argv \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.m4v" \) -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \;  | paste -sd+)
    if test -z "$t"
        set t 0
    end
    set t (math "$t")
    set h (math -s0 "$t/3600")
    set m (math -s0 "($t%3600)/60")
    set s (math  "$t%60")
    set ms (math -s0 "($s*1000)%1000")
    printf "%d h %d m %d s %d ms\n" $h $m $s $ms 2>/dev/null
end

function lsdur
    for i in (find $argv -maxdepth 1 \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.m4v" \) -type f)
        printf (set_color blue)/"$i"
        printf " "
        set_color green
        # ffprobe -v quiet -of csv=p=0 -show_entries format=duration "$i" | xargs -I "{}" python -c "t = {} ; h = t//3600; m = (t % 3600)// 60; s = t % 60; ms =(s * 1000) % 1000;  print('%d hours %d minutes %d seconds %d miliseconds' %(h, m, s, ms))"
        set t (ffprobe -v quiet -of csv=p=0 -show_entries format=duration "$i")
        if test -z "$t"
            continue
        end
        set h (math -s0 "$t/3600")
        set m (math -s0 "($t%3600)/60")
        set s (math  "$t%60")
        set ms (math -s0 "($s*1000)%1000")
        printf "%d h %d m %d s %d ms\n" $h $m $s $ms 2>/dev/null
        set_color normal
    end
end

function keep --argument-names file name
    if test -z "$name"
        set name (basename $file)
    end
    curl --progress-bar -T "$file" "https://free.keep.sh/$name"
end

function oshi --argument-names file name
    if test -z "$name"
        set name (basename $file)
    end
    curl --progress-bar -T "$file" "https://oshi.at/$name"|awk 'FNR==3{print $1}'
end

function tempup --argument-names file name
    if test -z "$name"
        set name (basename $file)
    end
    curl --progress-bar -T "$file" "https://temp.sh/$name"
end

venv_act $PWD
