#!/bin/bash

entries=" Shutdown\n Reboot\n Suspend \n Standby\n Logout\n Lockscreen"

selected=$(echo -e $entries|wofi -c ~/.config/wofi/config -s ~/.config/wofi/style.css --dmenu -W 170 -H 210 --location 3 -x -51 -y 6 -k /dev/null | awk '{print tolower($2)}')

case $selected in
  shutdown)
    systemctl poweroff;;
  reboot)
    systemctl reboot;;
  suspend)
    systemctl suspend;;
  standby)
    sleep 1 && hyprctl dispatch dpms off;;
  logout)
    systemctl terminate-session ${XDG_SESSION_ID-};;
  lockscreen)
    swaylock;;
esac
