#!/bin/bash

entries=" Shutdown\n Reboot\n Suspend\n Logout"

selected=$(echo -e "$entries" | wofi --width 250 --height 240 --dmenu --cache-file /dev/null --style ~/.config/wofi/style.css --prompt "System Operations")

case $selected in
  *Shutdown)
    systemctl poweroff;;
  *Reboot)
    systemctl reboot;;
  *Suspend)
    systemctl suspend;;
  *Logout)
    hyprctl dispatch exit 0;;
esac
