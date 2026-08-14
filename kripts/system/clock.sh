#!/usr/bin/env bash
# waybar clock: время в текст, а в tooltip — cal с датой (ДД.ММ.ГГ) по центру сверху
time=$(date +'%H:%M')
date_str=$(date +'%d.%m.%y')
tooltip="$(printf '%*s\n' $(( (21 + ${#date_str}) / 2 )) "$date_str"; cal)"
tooltip=$(printf '%s' "$tooltip" | sed ':a;N;$!ba;s/\n/\\n/g')
printf '{"text":"%s","tooltip":"%s"}\n' "$time" "$tooltip"
