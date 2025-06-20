if [ -z "$PROFILESOURCED" ]; then
    export PROFILESOURCED="Y"
    # echo PROFILESOURCED

    export PATH="$HOME/go/bin:$HOME/.local/go/bin:$HOME/.local/bin/:$PATH"
    export MANPATH="$HOME/.local/share/man:"

    export RUSTUP_HOME=~/.local/share/rustup
    export CARGO_HOME=~/.local/share/cargo

    [ -r $CARGO_HOME/env ] && source "$CARGO_HOME/env"

    [ -r $HOME/.profile_personal ] && source $HOME/.profile_personal
fi

if [ "$BASH" ]; then
    [ -r $HOME/.bashrc ] && source $HOME/.bashrc
fi
