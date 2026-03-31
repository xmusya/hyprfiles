#!/bin/bash

# Получаем ID текущего воркспейса
cur_ws=$(hyprctl activeworkspace -j | jq '.id')

# Считаем окна на текущем воркспейсе
count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $cur_ws)] | length")

if [ "$count" -gt 0 ]; then
    # Если окна есть: запоминаем их адреса и переносим в спец-воркспейс
    # Мы добавляем к адресу окна префикс воркспейса в отдельный файл-метку
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $cur_ws) | .address" > "/tmp/hypr_ws_${cur_ws}_windows"
    
    while read -r addr; do
        hyprctl dispatch movetoworkspacesilent "special:minimized_$cur_ws,address:$addr"
    done < "/tmp/hypr_ws_${cur_ws}_windows"
else
    # Если окон нет: ищем сохраненный список для ЭТОГО воркспейса
    if [ -f "/tmp/hypr_ws_${cur_ws}_windows" ]; then
        while read -r addr; do
            # Возвращаем только "свои" окна
            hyprctl dispatch movetoworkspace "$cur_ws,address:$addr"
        done < "/tmp/hypr_ws_${cur_ws}_windows"
        
        # Удаляем временный файл после восстановления
        rm "/tmp/hypr_ws_${cur_ws}_windows"
    fi
fi
