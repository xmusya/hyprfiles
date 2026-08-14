#!/usr/bin/env bash

# принудительно задаем переменные, чтобы fuzzel ожил
export PATH=$PATH:/usr/bin:/usr/local/bin
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# чистим резолв
sudo resolvconf -u

# ищем конфиги и убираем дубликаты
configs=$(sudo find /etc/wireguard -maxdepth 1 -name "*.conf" -printf "%f\n" | sed 's/\.conf//' | sort -u)

# выходим молча, если ничего нет
if [ -z "$configs" ]; then
    exit 1
fi

menu_options="󰏆 DISCONNECT ALL\n$configs"

# запускаем fuzzel с явным указанием окружения
choice=$(echo -e "$menu_options" | fuzzel --dmenu --prompt "WireGuard: " --width 30)

if [ "$choice" == "󰏆 DISCONNECT ALL" ]; then
    sudo wg show interfaces | xargs -r -I {} sudo wg-quick down {}
    notify-send "WireGuard" "все соединения отключены"
elif [ -n "$choice" ]; then
    sudo wg show interfaces | xargs -r -I {} sudo wg-quick down {}
    sudo wg-quick up "$choice"
    notify-send "WireGuard" "поднято: $choice"
fi
