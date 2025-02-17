# vim: set ft=tmux :

TMUX_PLUGIN_MANAGER_PATH="~/.local/share/tmux/plugins"

if-shell "test ! -d $TMUX_PLUGIN_MANAGER_PATH/tpm" {
   run 'git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm && $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins'
}

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
#set -g @plugin 'tmux-plugins/tmux-sensible'

set -g @plugin 'tmux-plugins/tmux-battery'

set -g @fuzzback-bind /
set -g @plugin 'roosta/tmux-fuzzback' # / - Fuzzy search scrollback buffer

set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @resurrect-capture-pane-contents 'off' # allow tmux-ressurect to capture pane contents
set -g @continuum-save-interval '5' # enable tmux-continuum save functionality 
set -g @continuum-restore 'on' # enable tmux-continuum restore functionality

# Pomodoro plugin
set -g @plugin 'olimorris/tmux-pomodoro-plus'
set -g @pomodoro_toggle 't'                    # Start/pause a Pomodoro/break
set -g @pomodoro_cancel 'T'                    # Cancel the current session
set -g @pomodoro_skip '_'                      # Skip a Pomodoro/break
set -g @pomodoro_mins 25                       # The duration of the Pomodoro
set -g @pomodoro_break_mins 2                  # The duration of the break after the Pomodoro completes
set -g @pomodoro_intervals 4                   # The number of intervals before a longer break is started
set -g @pomodoro_long_break_mins 15            # The duration of the long break
set -g @pomodoro_repeat 'off'                  # Automatically repeat the Pomodoros?
set -g @pomodoro_on "🍅 "
set -g @pomodoro_complete "#[fg=#00ff00]🍅 "
set -g @pomodoro_pause "#[fg=#ffff00]🍅 "
set -g @pomodoro_prompt_break "#[fg=#00ff00]🕤 ? "
set -g @pomodoro_prompt_pomodoro "#[fg=#808080]🕤 ? "
set -g @pomodoro_disable_breaks 'off'          # Turn off breaks
set -g @pomodoro_menu_position "R"             # The location of the menu relative to the screen
set -g @pomodoro_sound 'off'                   # Sound for desktop notifications (Run `ls /System/Library/Sounds` for a list of sounds to use on Mac)
if-shell 'test -z "$SSH_TTY"' {
    set -g @pomodoro_notifications 'on'           # Enable desktop notifications from your terminal
}
set -g @pomodoro_granularity 'on'             # Enables MM:SS (ex: 00:10) format instead of the default (ex: 1m)

## Theme

### Catppuccin theme
set -g @plugin 'catppuccin/tmux#v2.1.2'
source-file ~/.config/tmux/themes/catppuccin.tmux

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b "$TMUX_PLUGIN_MANAGER_PATH/tpm/tpm"
