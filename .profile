if [ -z "$PROFILESOURCED" ]; then
    export PROFILESOURCED="Y"
    # echo PROFILESOURCED

    export PATH="$HOME/.local/scripts:$HOME/.config/nsxiv/scripts:$HOME/.config/emacs/bin:$HOME/go/bin:$HOME/.local/go/bin:$HOME/.local/bin:$PATH"
    export PYTHONPATH="$HOME/.local/mypyprogs${PYTHONPATH:+:$PYTHONPATH}"
    export MANPATH="$HOME/.local/share/man:"

    export RUSTUP_HOME=~/.local/share/rustup
    export CARGO_HOME=~/.local/share/cargo

    [ -r $CARGO_HOME/env ] && source "$CARGO_HOME/env"

    [ -r $HOME/.profile_local ] && source $HOME/.profile_local
fi

if [ "$BASH" ]; then
    [ -r $HOME/.bashrc ] && source $HOME/.bashrc
fi
