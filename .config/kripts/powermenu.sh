#!/bin/bash
entries="󰑐 Restart Waybar\n󰌾 Lock\n󰃢 Clear RAM\n󰜉 Reboot\n󰐥 Shutdown\n󰗼 Logout"
selected=$(echo -e "$entries" | wofi --dmenu --cache-file /dev/null --location 0 --width 250 --height 320 --style ~/.config/wofi/style.css | awk '{print $2}')

case $selected in
    Restart) ~/.config/kripts/waybar_restart.sh ;;
    Lock)    hyprlock ;;
    Clear)
        notify-send "System" "Cleaning RAM..."
        sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches
        notify-send "System" "RAM cleared!" ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
    Logout)   hyprctl dispatch exit ;;
esac
