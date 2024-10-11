#!/bin/bash
# modeline=$(cvt --reduced 1920 1080 60 | tail -n 1|cut -d " " -f1 --complement)
modeline=$(cvt 1920 1080 50 | tail -n 1|cut -d " " -f1 --complement)
# echo ${modeline}
mode=$(echo ${modeline}|cut -d " " -f1)
# echo ${mode}
xrandr --newmode ${modeline}
xrandr --addmode HDMI-1-1 ${mode}
xrandr --output HDMI-1-1 --mode ${mode} -r 15
