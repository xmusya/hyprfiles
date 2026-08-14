#!/usr/bin/env bash

# 1. эффекты: только звезды НЕ ТРОГАТЬ!
polychromatic-cli -d keyboard -o starlight -c FFFFFF -p single:2
sleep 2

# 2. фиксируем чистый пастельно-зеленый для финала
hex_end="A1E3A1"

# стартовый глубокий хвойный темно-зеленый
hex_start="0F2913"

# разбиваем стартовый цвет на r, g, b
r_start=$((16#${hex_start:0:2}))
g_start=$((16#${hex_start:2:2}))
b_start=$((16#${hex_start:4:2}))

# разбиваем финальный цвет на r, g, b
r_end=$((16#${hex_end:0:2}))
g_end=$((16#${hex_end:2:2}))
b_end=$((16#${hex_end:4:2}))

# врубаем сначала стартовый глубокий нефрит
polychromatic-cli -o static -c "$hex_start" -d keyboard
sleep 3.0

# 3. плавный переход к финалу за 3 шага
for step in 1 2 3; do
    # высчитываем промежуточный цвет
    r_curr=$(( r_start + (r_end - r_start) * step / 3 ))
    g_curr=$(( g_start + (g_end - g_start) * step / 3 ))
    b_curr=$(( b_start + (b_end - b_start) * step / 3 ))

    # собираем в hex
    current_hex=$(printf "%02X%02X%02X" $r_curr $g_curr $b_curr)

    # отправляем на клаву
    polychromatic-cli -o static -c "$current_hex" -d keyboard
    sleep 1
done
