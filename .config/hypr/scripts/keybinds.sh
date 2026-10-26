#!/bin/sh
# Show Hyprland keybindings that have a description (Super+F1). Press again to close.
pkill -x rofi && exit 0

hyprctl binds -j | jq -r '
  def has($bit): (.modmask / $bit | floor) % 2 == 1;
  .[] | select(.has_description)
  | [ if has(64) then "SUPER" else empty end,
      if has(4)  then "CTRL"  else empty end,
      if has(8)  then "ALT"   else empty end,
      if has(1)  then "SHIFT" else empty end,
      (.key | sub("mouse:272"; "LMB") | sub("mouse:273"; "RMB")) ] as $combo
  | "\($combo | join(" + "))\t\(.description)"
' | column -t -s "$(printf '\t')" | rofi -dmenu -i -p "Keybinds"
