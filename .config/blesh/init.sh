bleopt complete_auto_delay=100

bleopt prompt_eol_mark='⏎'

# Disable error exit marker like "[ble: exit %d]"
bleopt exec_errexit_mark=

# Disable exit marker like "[ble: exit]"
bleopt exec_exit_mark=

# Disable some other markers like "[ble: ...]"
bleopt edit_marker=
bleopt edit_marker_error=


# Disable bell
bleopt edit_vbell=
bleopt decode_error_char_vbell=
bleopt decode_error_cseq_vbell=
bleopt decode_error_kseq_vbell=


bleopt color_scheme=catppuccin_mocha

# bleopt history_share=1

# vim-mode start

source "$_ble_base/lib/vim-arpeggio.sh"
bleopt vim_arpeggio_timeoutlen=100
ble/lib/vim-arpeggio.sh/bind -m vi_imap -f jk vi_imap/normal-mode
ble/lib/vim-arpeggio.sh/bind -m vi_imap -f kj vi_imap/normal-mode

bleopt keymap_vi_mode_show:=


function blerc/vim-mode-hook {

  # Write your settings for vi/vim mode here
  ble-bind -m vi_imap -f 'C-c' discard-line
  ble-bind -m vi_nmap -f 'C-c' discard-line

}
blehook/eval-after-load keymap_vi blerc/vim-mode-hook

source "$_ble_base/lib/vim-surround.sh"

function ble/prompt/backslash:my/vim-mode {
  bleopt keymap_vi_mode_update_prompt:=1
  case $_ble_decode_keymap in
  (vi_[on]map) ble/prompt/process-prompt-string '\g{fg=red}[N]' ;;
  (vi_xmap) ble/prompt/process-prompt-string '\g{fg=purple}[V]' ;;
  (*) ble/prompt/process-prompt-string '\g{fg=green}[I]' ;;
  esac
}


# vim-mode end

# Set up fzf
ble-import -d integration/fzf-completion
ble-import -d integration/fzf-key-bindings -C 'ble-bind -m vi_nmap -f C-r vi_imap/redo'

_ble_contrib_fzf_git_config=key-binding
ble-import -d integration/fzf-git



# Abbreviations
function blerc/define-sabbrev-branch {
  function blerc/sabbrev-git-branch {
    ble/util/assign-array COMPREPLY "git branch | sed 's/^\*\{0,1\}[[:blank:]]*//'" 2>/dev/null
  }
  ble-sabbrev -m '\branch'=blerc/sabbrev-git-branch
}
blehook/eval-after-load complete blerc/define-sabbrev-branch

ble-sabbrev dotcommit='dotfiles commit -m "Update $(date)"'
ble-sabbrev dv="GIT_DIR=$DOT_GIT_DIR GIT_WORK_TREE=$DOT_WORK_TREE $EDITOR"


# Prompt

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  user_prompt="\g{bold,fg=#f2cdcd}\u\g{none}@\g{bold,fg=navy}\h "
fi

PS1="\q{my/vim-mode} ${user_prompt}\g{fg=cyan}\w \g{fg=red}❯\g{fg=yellow}❯\g{fg=green}❯\g{none} "

ble-import contrib/prompt-git

error_exit_prompt="\$(EXIT_STATUS=\$? ;if [ \$EXIT_STATUS != 0 ]; then echo '\g{fg=red}✘ '\$EXIT_STATUS; fi)"
bleopt prompt_rps1="$error_exit_prompt \q{contrib/git-branch}"
