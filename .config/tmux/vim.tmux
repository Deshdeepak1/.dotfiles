# vim: set ft=tmux :

set -g mode-keys vi
set -g focus-events on


is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

bind-key -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -T NAVIGATOR"

bind-key -T NAVIGATOR h select-pane -L
bind-key -T NAVIGATOR j select-pane -D
bind-key -T NAVIGATOR k select-pane -U
bind-key -T NAVIGATOR l select-pane -R

bind-key -rT NAVIGATOR 'C-w' 'send-keys C-w'


bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

# image.nvim
set -gq allow-passthrough on
set -g visual-activity off
