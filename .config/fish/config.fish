set fish_greeting

fish_add_path -p ~/.local/scripts ~/.local/bin
set fish_cursor_unknown block
export EDITOR="nvim"
export VISUAL="nvim"

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        sx 2> /dev/null
    end
end


if status is-interactive
    if ! test -n "$TMUX"
        # OFF by default: shell editor wm de palette
        PF_INFO="ascii title os host kernel uptime pkgs memory wm" pfetch
        #neofetch
    end
end

# Git

# git config --global user.email "rkdeshdeepak1@gmail.com"
# git config --global user.name "Deshdeepak"
# git config --global credential.helper cache/store

# Dot files management
alias dotfiles="git --git-dir=$HOME/.dotfiles"
#dotfiles remote add https://gitea.deshdeepak.xyz/deshdeepak/.dotfiles
#dotfiles pull -u origin master
#dotfiles config status.showUntrackedFiles no
#dotfiles config --local credential.helper cache/store
#git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local core.worktree $HOME
abbr dv "GIT_DIR=~/.dotfiles $EDITOR"

# Abbreviations
abbr    fpac    "pacman -Slq | fzf -m --preview 'cat (pacman -Si {1} | psub) (pacman -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro sudo pacman -Sy"
abbr    fyay    "yay -Slq | fzf -m --preview 'cat (yay -Si {1} | psub) (yay -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  yay -Sy"
abbr    fparu   "paru -Slq | fzf -m --preview 'cat (paru -Si {1} | psub) (paru -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  paru -Sy"
abbr av ". venv/bin/activate.fish"
abbr ah ". ~/hvenv/bin/activate.fish"
# abbr    fdur    "find . -iname \"*.mp4\" -exec ffprobe -v quiet -of csv=p=0 -show_entries format=duration {} \;  | paste -sd+ | xargs -I \"{}\" python -c \"t = {} ; h = t//3600; m = (t % 3600)// 60; s = t % 60; ms =(s * 1000) % 1000;  print('%d hours %d minutes %d seconds %d miliseconds' %(h, m, s, ms))\""
abbr p "sudo pacman -Syyu"
abbr v "$EDITOR"
abbr n "$EDITOR"


# Aliases
alias ls="exa --icons --group-directories-first"
alias cat="bat"
alias tb="nc termbin.com 9999"
alias tbc="nc termbin.com 9999 | xclip -selection c"
alias jqc="jq -C | cat"
alias octave="octave -q"
alias dragon="dragon-drop"
alias aria2cc="aria2c -c -s 16 -x 16 -k 1M -j 32  --file-allocation none"
alias xsc="xclip -sel clipboard"
# export SHELL="sh"

export FZF_DEFAULT_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_CTRL_T_COMMAND="fd --exclude '.git/' --hidden --type f"
export FZF_ALT_C_COMMAND="fd --exclude '.git/' --hidden --type d"
set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"


function venv_act --on-variable PWD --description 'change directory - activate venv'
    # builtin cd $param $argv
    # Check if we are inside a git directory
    if git rev-parse --show-toplevel &>/dev/null
        set venvdir "$(realpath (git rev-parse --show-toplevel))/venv"
    else
        set venvdir "./venv"
    end

    set actvate_file "$venvdir/bin/activate.fish"

    # If venv is not activated or a different venv is activated and venv exist.
    if test "$VIRTUAL_ENV" != "$venvdir" -a -f "$actvate_file"
        source "$actvate_file"
    # If venv activated but the current (git) dir has no venv.
    # else if not test -z "$VIRTUAL_ENV" -o -e "$gitdir/.venv"
    #     deactivate
    end
end

# ffmpeg record
# ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab  -i :1 -t 5 output.mp4
# ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab  -i :1.0+100,200 -t 5 output.mp4 # 100,200



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
