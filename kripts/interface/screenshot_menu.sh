#!/usr/bin/env bash
options="Select region\nFull screen\nSelect window"
choice=$(echo -e "$options" | fuzzel --dmenu --prompt "Screenshot mode: " --width 25 --lines 3)

case $choice in
    "Select region") hyprshot -m region --freeze -o ~/Pictures/Screenshots/ ;;
    "Full screen") hyprshot -m output -o ~/Pictures/Screenshots/ ;;
    "Select window") hyprshot -m window -o ~/Pictures/Screenshots/ ;;
esac
