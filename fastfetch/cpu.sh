#!/usr/bin/env bash
out=$(fastfetch -s cpu:cpuusage --pipe --logo none 2>/dev/null)
name=$(printf '%s\n' "$out" | sed -n '1s/^[^:]*: //p')
use=$(printf '%s\n' "$out" | sed -n '2s/^[^:]*: //p')
pct=${use%\%}
[ -n "$pct" ] || pct=0
if   [ "$pct" -le 25 ]; then c="38;2;0;228;121"
elif [ "$pct" -le 49 ]; then c="38;2;255;200;60"
elif [ "$pct" -le 75 ]; then c="38;2;255;140;0"
else                          c="38;2;255;60;60"
fi
printf '%s (\033[%sm%s\033[0m)\n' "$name" "$c" "$use"
