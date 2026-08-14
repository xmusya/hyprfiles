#!/usr/bin/env bash

options=" Screenshot Menu\n󰸉 Wallpaper Picker\n Power Menu\n VPN Management\n App Menu\n Open Alacritty\n Open Firefox\n Kill Active Game\n󰞅 Emoji Picker\n󰍽 Mouse Clicker\n󰌌 Keyboard clicker\n󰌌 Launch Typer"

choice=$(echo -e "$options" | fuzzel --dmenu --prompt "The Control Center: " --width 30)

case $choice in
    *Screenshot*) ~/.config/kripts/interface/screenshot_menu.sh ;;
    *Wallpaper*) python3 ~/.config/kripts/system/wallpaper_picker.py ;;
    *Power*) ~/.config/kripts/interface/powermenu.sh ;;
    *VPN*) ~/.config/kripts/system/vpn_menu.sh ;;
    *App*) ~/.config/kripts/interface/apps.sh ;;
    *Alacritty*) alacritty & disown ;;
    *Firefox*) firefox & disown ;;
    *Kill*) hyprctl kill ;;
    *Emoji*) ~/.config/kripts/interface/emoji_picker.sh ;;
    *Key*) python ~/.config/kripts/system/hyprlandport/keyclick.py ;;
    *Clicker*) python ~/.config/kripts/system/hyprlandport/clicker.py ;;
    *Launch*Typer*) alacritty -e python ~/.config/kripts/typer/typer.py -t 30 -l en & disown ;;
esac
