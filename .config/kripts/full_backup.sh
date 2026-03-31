#!/bin/bash

# Определяем дату и пути
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M)
DEST="/mnt/ssd/hyprbp/$BACKUP_DATE"

echo "Начинаю фулл бэкап в $DEST..."

# Создаем структуру папок
mkdir -p "$DEST/hypr"
mkdir -p "$DEST/kripts"
mkdir -p "$DEST/waybar"
mkdir -p "$DEST/wofi"
mkdir -p "$DEST/mako"

# Копируем всё важное
cp -r ~/.config/hypr/hyprland.conf "$DEST/hypr/"
cp -r ~/.config/kripts/* "$DEST/kripts/"
cp -r ~/.config/waybar/* "$DEST/waybar/"
cp -r ~/.config/wofi/* "$DEST/wofi/"
[ -d ~/.config/mako ] && cp -r ~/.config/mako/* "$DEST/mako/"

# Создаем симлинк "latest" для быстрого доступа
rm -f /mnt/ssd/hyprbp/latest
ln -s "$DEST" /mnt/ssd/hyprbp/latest

notify-send "Backup" "Фулл бэкап завершен успешно!"
echo "Готово! Всё сохранено в $DEST"
