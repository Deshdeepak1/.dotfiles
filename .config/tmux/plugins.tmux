TMUX_PLUGIN_MANAGER_PATH="~/.local/share/tmux/plugins"

if-shell "test ! -d $TMUX_PLUGIN_MANAGER_PATH/tpm" {
   run 'git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm && $TMUX_PLUGIN_MANAGER_PATH/tpm/bin/install_plugins'
}

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g escape-time 10 # Fix windows terminal pushing escape sequences

set -g @plugin 'tmux-plugins/tmux-battery'

set -g @fuzzback-bind /
set -g @plugin 'roosta/tmux-fuzzback' # / - Fuzzy search scrollback buffer

set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @continuum-save-interval '2' # enable tmux-continuum functionality
set -g @resurrect-capture-pane-contents 'off' # allow tmux-ressurect to capture pane contents
set -g @continuum-save-interval '5' # enable tmux-continuum functionality

## Theme

### Catppuccin theme
set -g @plugin 'catppuccin/tmux#v2.1.2'
source-file ~/.config/tmux/themes/catppuccin.tmux

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b "$TMUX_PLUGIN_MANAGER_PATH/tpm/tpm"
