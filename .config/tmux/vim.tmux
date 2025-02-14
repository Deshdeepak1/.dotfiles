# vim: set ft=tmux :

set -g mode-keys vi
set -g focus-events on

bind -n C-w switch-client -T NAVIGATOR

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?\.?(view|n?vim?x?)(-wrapped)?(diff)?$'"

bind-key -rT NAVIGATOR 'h' if-shell "$is_vim" 'send-keys C-w h' 'select-pane -L'
bind-key -rT NAVIGATOR 'j' if-shell "$is_vim" 'send-keys C-w j' 'select-pane -D'
bind-key -rT NAVIGATOR 'k' if-shell "$is_vim" 'send-keys C-w k' 'select-pane -U'
bind-key -rT NAVIGATOR 'l' if-shell "$is_vim" 'send-keys C-w l' 'select-pane -R'
bind-key -rT NAVIGATOR 'v' if-shell "$is_vim" 'send-keys C-w v'
bind-key -rT NAVIGATOR 's' if-shell "$is_vim" 'send-keys C-w s'
bind-key -rT NAVIGATOR 'c' if-shell "$is_vim" 'send-keys C-w c'
bind-key -rT NAVIGATOR 'q' if-shell "$is_vim" 'send-keys C-w q'
bind-key -rT NAVIGATOR 't' if-shell "$is_vim" 'send-keys C-w t'
bind-key -rT NAVIGATOR 'b' if-shell "$is_vim" 'send-keys C-w b'
bind-key -rT NAVIGATOR 'p' if-shell "$is_vim" 'send-keys C-w p'
bind-key -rT NAVIGATOR 'w' if-shell "$is_vim" 'send-keys C-w w'
bind-key -rT NAVIGATOR 'W' if-shell "$is_vim" 'send-keys C-w W'
bind-key -rT NAVIGATOR 'n' if-shell "$is_vim" 'send-keys C-w n'
bind-key -rT NAVIGATOR 'x' if-shell "$is_vim" 'send-keys C-w x'
bind-key -rT NAVIGATOR 'r' if-shell "$is_vim" 'send-keys C-w r'
bind-key -rT NAVIGATOR 'R' if-shell "$is_vim" 'send-keys C-w R'
bind-key -rT NAVIGATOR 'o' if-shell "$is_vim" 'send-keys C-w o'
bind-key -rT NAVIGATOR 'f' if-shell "$is_vim" 'send-keys C-w f'
bind-key -rT NAVIGATOR 'F' if-shell "$is_vim" 'send-keys C-w F'


bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

# image.nvim
set -gq allow-passthrough on
set -g visual-activity off
