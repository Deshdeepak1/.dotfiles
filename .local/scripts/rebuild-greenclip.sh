#!/bin/bash
# Triggered by /etc/pacman.d/hooks/rebuild-greenclip.hook whenever one of
# greenclip's Haskell deps gets upgraded, since Arch's Haskell .so files are
# hash-versioned and break greenclip's dynamic linking on every such upgrade.

while [ -e /var/lib/pacman/db.lck ]; do
    sleep 1
done

export DISPLAY="${DISPLAY:-:1}"
export XAUTHORITY="${XAUTHORITY:-$HOME/.local/share/sx/xauthority}"

exec kitty --title "greenclip rebuild" -e bash -c '
    echo "greenclip Haskell deps changed on last update -- rebuilding..."
    # Also rebuild greenclip'\''s AUR-only Haskell deps (haskell-wordexp,
    # haskell-semigroups), which break the same way on ghc-libs bumps.
    yay -S --rebuild --noconfirm $(pacman -Qmq | grep "^haskell-" | grep -v -- "-debug$") greenclip
    systemctl --user restart greenclip.service
    echo
    echo "Done. Press enter to close."
    read
'