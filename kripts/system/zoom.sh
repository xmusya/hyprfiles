#!/usr/bin/env bash

# Достаем текущий зум
current=$(hyprctl getoption cursor:zoom_factor | awk '/float/ {print $2}')

# Твой аристократичный шаг 0.55
step=0.33

case $1 in
    inc)
        # Увеличиваем
        new=$(awk "BEGIN {print $current + $step}")
        hyprctl eval "hl.config({ cursor = { zoom_factor = $new } })"
        ;;
    dec)
        # Уменьшаем, но не ниже 1.0
        is_greater=$(awk "BEGIN {print ($current > 1.0) ? 1 : 0}")
        if [ "$is_greater" -eq 1 ]; then
            new=$(awk "BEGIN {print $current - $step}")
            # Проверка, чтобы не уйти в минус или меньше единицы
            is_too_low=$(awk "BEGIN {print ($new < 1.0) ? 1 : 0}")
            if [ "$is_too_low" -eq 1 ]; then new=1.0; fi
            hyprctl eval "hl.config({ cursor = { zoom_factor = $new } })"
        else
            hyprctl eval "hl.config({ cursor = { zoom_factor = 1.0 } })"
        fi
        ;;
    reset)
        hyprctl eval "hl.config({ cursor = { zoom_factor = 1.0 } })"
        ;;
esac


# this is taken from end-4 dotfiles https://github.com/end-4/dots-hyprland
