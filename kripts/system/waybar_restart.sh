#!/usr/bin/env bash

pkill -f '^waybar$'
sleep 0.3

waybar & disown
