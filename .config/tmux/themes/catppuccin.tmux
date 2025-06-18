# vim: set ft=tmux :

set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_window_number_position "right"
set -ogq @catppuccin_window_text "#{s|.*/||:#{s|$HOME|~|:pane_current_path}}|#W"
set -ogq @catppuccin_window_current_text "#{s|$HOME|~|:pane_current_path}"
set -ogq @catppuccin_window_flags "icon"


# Load catppuccin
run "$TMUX_PLUGIN_MANAGER_PATH/tmux/catppuccin.tmux"

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right ""
set -ag status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_pomodoro_plus}"

if-shell 'test -z "$TERMUX_VERSION"' {
    set -agF status-right "#{E:@catppuccin_status_battery}"
}

set -ag status-right "#{E:@catppuccin_status_session}"

