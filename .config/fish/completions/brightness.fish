complete -c brightness -f

complete -c brightness -n "not __fish_seen_subcommand_from up down" -a up \
    -d "Increase brightness"

complete -c brightness -n "not __fish_seen_subcommand_from up down" -a down \
    -d "Decrease brightness"

# Second argument (monitor names)
complete -c brightness \
    -n "__fish_seen_subcommand_from up down; and test (count (commandline -opc)) -eq 2" \
    -a "(xrandr --query | awk '/ connected/ {print \$1}')" -d "Display output"
