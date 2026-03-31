 #!/bin/bash

# Убиваем всё, что может держать шину

killall waybar

pkill xdg-desktop-portal-hyprland

pkill xdg-desktop-portal


# Обновляем окружение (критично для Watcher)

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP


# Запускаем портал (он создаст Watcher)

/usr/lib/xdg-desktop-portal-hyprland &

sleep 2


# Запускаем Waybar

waybar & 
