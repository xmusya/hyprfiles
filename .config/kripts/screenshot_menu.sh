#!/bin/bash

# Опции для меню
options="Select region\nFull screen\nSelect window"

# Показываем wofi и ловим выбор
choice=$(echo -e "$options" | wofi --dmenu --config ~/.config/wofi/config --style ~/.config/wofi/style.css --prompt "Screenshot mode:")

case $choice in
    "Select region")
        # Флаг -f (freeze) замораживает экран в hyprshot
        hyprshot -m region --freeze -o /home/kowk/Pictures/Screenshots/
        ;;
    "Full screen")
        hyprshot -m output -o /home/kowk/Pictures/Screenshots/
        ;;
    "Select window")
        hyprshot -m window -o /home/kowk/Pictures/Screenshots/
        ;;
esac
