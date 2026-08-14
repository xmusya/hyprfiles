#!/usr/bin/env bash
entries="󰓧 Restart Waybar\n󰌾 Lock\n󰜉 Reboot\n󰐥 Shutdown\n󰗼 Logout"
selected=$(echo -e "$entries" | fuzzel --dmenu --width 24 --lines 6 --prompt "Power: ")

case $selected in
    *Restart*Waybar*|*Waybar*) pkill waybar; sleep 1; waybar & disown ;;
    *Lock*) hyprlock & disown ;;
    *Reboot*) systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
    *Logout*) pkill -9 -f hyprland ;;
esac
