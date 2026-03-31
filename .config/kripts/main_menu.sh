#!/bin/bash

# Опции только по твоему списку:
options="󰄀 Screenshot Menu\n󰐥 Power Menu\n󰏆 VPN Management\n󰘳 Hide/Show Waybar\n󰀻 App Menu\n󰄛 Open Kitty\n󰈹 Open Firefox\n󰱶 Kill Active Game"

# Запуск wofi
choice=$(echo -e "$options" | wofi --dmenu --prompt "The Control Center:" --width 400 --height 450)

case $choice in
    *Screenshot*)
        ~/.config/kripts/screenshot_menu.sh
        ;;
    *Power*)
        ~/.config/kripts/powermenu.sh
        ;;
    *VPN*)
        ~/.config/kripts/vpn_menu.sh
        ;;
    *Waybar*)
        ~/.config/kripts/toggle_waybar.sh
        ;;
    *App*)
        pkill wofi || wofi --show drun
        ;;
    *Kitty*)
        kitty &
        ;;
    *Firefox*)
        firefox &
        ;;
    *Kill*)
        hyprctl kill
        ;;
esac
