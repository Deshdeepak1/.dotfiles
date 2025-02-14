# vim: set ft=tmux :

# Terminal

set -g default-terminal "$TERM"

if-shell 'test -z "$TERMUX_VERSION"' {
    set -ga terminal-features ",$TERM:usstyle"
}
set -ga terminal-features ",$TERM:RGB"


if-shell 'test "$WIN_TERMINAL" = "ms-terminal"' {
    set -sg escape-time 100 # Fix windows terminal pushing escape sequences
}

set -g set-clipboard on
set -g history-limit 100000
set -g set-titles on
set -g set-titles-string "tmux #S:#I #W"

set -g mouse on
set -g prefix `
bind ` send-prefix
set -g prefix2 C-b


# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on

# Splits
#unbind %
#unbind '"'
bind -N "Horizontal Split" | split-window -h -c "#{pane_current_path}" -l 30%
bind -N "Vertical Split" - split-window -v -c "#{pane_current_path}" -l 30%

# Split Navigations:
bind -N "Select the pane above the active pane" -r k select-pane -U
bind -N "Select the pane below the active pane" -r j select-pane -D
bind -N "Select the pane to the left of the active pane" -r h select-pane -L
bind -N "Select the pane to the right of the active pane" -r l select-pane -R

# Split Resize:
bind -N "Resize the pane up by 5" -r K resize-pane -U 5
bind -N "Resize the pane down by 5" -r J resize-pane -D 5
bind -N "Resize the pane left by 5" -r H resize-pane -L 5
bind -N "Resize the pane right by 5" -r L resize-pane -R 5

# Windows
bind -N "Create a new window" -r c new-window -c "#{pane_current_path}"
bind -N "Select the previously current window" -r b last-window
bind -N "Select the next pane" -r n next-window
bind -N "Select the previous window" -r p previous-window

# Panes
bind -N "Select the next pane" -r o select-pane -t :.+
bind -N "Move to last and maximize pane" -r m last-pane -Z 
## Display menu using < , > , then respawn using R

# Sessions
bind -N "Kill session" C-k confirm-before kill-session

# Status
bind -N "Toggle status" -r '\' set -g status
set -g status-position top
set -g status-interval 5
set -g status-keys vi
set -g status off

set -g pane-border-indicators arrows
set -g pane-border-style fg=blue # maybe overriden by colorscheme
