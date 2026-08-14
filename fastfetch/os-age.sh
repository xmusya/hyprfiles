#!/usr/bin/env bash
birth=$(stat -c %W /)
if [ "$birth" = "0" ] || [ -z "$birth" ]; then
    birth=$(stat -c %X /)
fi
now=$(date +%s)
echo "$(( (now - birth) / 86400 )) days"
