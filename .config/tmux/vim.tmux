# vim: set ft=tmux

set -g mode-keys vi

bind -n C-w switch-client -T NAVIGATOR

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

bind-key -rT NAVIGATOR 'h' if-shell "$is_vim" 'send-keys C-w h' 'select-pane -L'
bind-key -rT NAVIGATOR 'j' if-shell "$is_vim" 'send-keys C-w j' 'select-pane -D'
bind-key -rT NAVIGATOR 'k' if-shell "$is_vim" 'send-keys C-w k' 'select-pane -U'
bind-key -rT NAVIGATOR 'l' if-shell "$is_vim" 'send-keys C-w l' 'select-pane -R'


bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

# image.nvim
set -gq allow-passthrough on
set -g visual-activity off
