#!/usr/bin/env bash

options=" Screenshot Menu
 VPN Management
 App Menu
󰞅 Emoji Picker
 Open Firefox
 Arch Wiki Viewer
󰍽 Mouse Clicker
󰌌 Keyboard clicker
󰌌 Launch Typer"

choice=$(echo -e "$options" | fuzzel --dmenu --prompt "The Control Center: " --width 30)

case $choice in
    *VPN*)              ~/.config/kripts/system/vpn_menu.sh ;;
    *App*)              ~/.config/kripts/apps.sh ;;
    *Emoji*)            rofi -modi emoji -show emoji -emoji-mode copy -me-accept-entry MousePrimary -me-select-entry '' ;;
    *Firefox*)          firefox & disown ;;
    *Wiki*)             python ~/.config/kripts/wikiHubs/wikihub & disown ;;
    *Mouse*)            python ~/.config/kripts/input/clickers/clicker.py ;;
    *Keyboard*)         python ~/.config/kripts/input/clickers/keyclick.py ;;
    *Launch*Typer*)     alacritty -e python ~/.config/kripts/typer/typer.py -t 30 -l en & disown ;;
esac
