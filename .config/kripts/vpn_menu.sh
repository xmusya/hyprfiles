#!/bin/bash

# апдейтим зачемто
sudo resolvconf -u

# 1. Получаем список конфигов (убираем путь и расширение .conf)
# Используем find, он надежнее переваривает список файлов
configs=$(sudo find /etc/wireguard -name "*.conf" -printf "%f\n" | sed 's/\.conf//')

# 2. Если пусто — уведомляем
if [ -z "$configs" ]; then
    notify-send "WireGuard" "Конфиги не найдены в /etc/wireguard"
    exit 1
fi

# 3. Меню
menu_options="󰏆 DISCONNECT ALL\n$configs"
choice=$(echo -e "$menu_options" | wofi --dmenu --prompt "WireGuard:" --width 300 --height 400)

# 4. Логика
if [ "$choice" == "󰏆 DISCONNECT ALL" ]; then
    # Гасим всё, что поднято
    sudo wg show interfaces | xargs -r -I {} sudo wg-quick down {}
    notify-send "WireGuard" "Все соединения отключены"
elif [ -n "$choice" ]; then
    # Гасим старое и молча поднимаем новое (без kitty)
    sudo wg show interfaces | xargs -r -I {} sudo wg-quick down {}
    sudo wg-quick up "$choice"
    notify-send "WireGuard" "Поднято: $choice"
fi
