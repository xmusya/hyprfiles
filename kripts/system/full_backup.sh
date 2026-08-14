#!/usr/bin/env bash

# цвета для красивого вывода
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
nc='\033[0m' # No Color

# функции для вербоз логов
log_info() {
    echo -e "${blue}[INFO]${nc} $1"
}

log_ok() {
    echo -e "${green}[OK]${nc} $1"
}

log_error() {
    echo -e "${red}[ERROR]${nc} $1"
}

# определим дату и пути
backup_date=$(date +%Y-%m-%d_%H-%M)
parent_dir="/mnt/backups/hyprbp"
dest="$parent_dir/$backup_date"

# проверка на доступность пути
if [ ! -d "$parent_dir" ]; then
    log_error "путь $parent_dir не найден. перепроверь!"
    exit 1
fi

log_info "начинаю фулл бэкап в $dest..."

# создаем структуру папок
if mkdir -p "$dest"; then
    log_ok "директория бэкапа создана"
else
    log_error "не удалось создать директорию $dest"
    exit 1
fi

# делаем финальный фетч на память
if command -v fastfetch &> /dev/null; then
    if fastfetch --pipe > "$dest/old_system_fetch.txt"; then
        log_ok "fastfetch снимок сохранен"
    else
        log_error "не удалось сохранить fastfetch снимок"
    fi
else
    log_info "fastfetch не установлен, пропускаю"
fi

# функция для безопасного копирования директорий с логами
backup_dir() {
    local src=$1
    local name=$2
    if [ -d "$src" ]; then
        if cp -r "$src" "$dest/$name" 2>/dev/null; then
            log_ok "скопировано: $name"
        else
            log_error "ошибка копирования: $name"
        fi
    else
        log_info "пропущено (не найдено): $name"
    fi
}

# функция для безопасного копирования файлов
backup_file() {
    local src=$1
    local name=$2
    if [ -f "$src" ]; then
        if cp "$src" "$dest/$name" 2>/dev/null; then
            log_ok "скопирован файл: $name"
        else
            log_error "ошибка копирования файла: $name"
        fi
    else
        log_info "пропущен файл (не найден): $name"
    fi
}

log_info "копирую конфиги..."
backup_dir ~/.config/hypr "hypr"
backup_dir ~/.config/niri "niri"
backup_dir ~/.config/kripts "kripts"
backup_dir ~/.config/waybar "waybar"
backup_dir ~/.config/fuzzel "fuzzel"
backup_dir ~/.config/rofi "rofi"
backup_dir ~/.config/alacritty "alacritty"
backup_dir ~/.config/mako "mako"
backup_dir ~/.config/fish "fish"
backup_dir ~/.config/fastfetch "fastfetch"
backup_dir ~/.config/noctalia "noctalia"
backup_dir ~/.local/share/konsole "konsole"
backup_file ~/.config/fishrc "fishrc"
backup_file ~/.config/mozilla/firefox/1y4ynlvq.default-release "user.js"

log_info "копирую шрифты, цвета, обои и шеллы..."
backup_file ~/.bashrc "bashrc"
backup_file ~/.zshrc "zshrc"
backup_dir ~/.zsh "zsh_plugins"
backup_dir ~/.local/share/fonts "fonts"
backup_dir ~/.local/share/color-schemes "color-schemes"
backup_dir ~/Pictures "pictures"

log_info "копирую тему Telegram..."
theme_file="$HOME/.config/telegram-desktop/themes/noctalia.tdesktop-theme"
if [ -f "$theme_file" ]; then
    mkdir -p "$dest/Telegram_Theme"
    if cp "$theme_file" "$dest/Telegram_Theme/" 2>/dev/null; then
        log_ok "тема Telegram успешно скопирована"
    else
        log_error "ошибка копирования темы Telegram"
    fi
else
    log_info "файл темы Telegram не найден по пути $theme_file"
fi

if [ -d /etc/wireguard ]; then
    log_info "запрашиваю root для копирования wireguard..."
    if sudo cp -r /etc/wireguard "$dest/wireguard" 2>/dev/null; then
        log_ok "wireguard успешно скопирован"
    else
        log_error "не удалось скопировать wireguard"
    fi
else
    log_info "wireguard конфиги не найдены"
fi

log_info "копирую сейвы DELTARUNE..."
backup_dir ~/.wine-deltarune/drive_c/users/pasha/AppData/Local/DELTARUNE "deltarune_saves"

log_info "копирую документацию..."
backup_dir ~/Documents/ExterapluginsDOCS "docs_ExterapluginsDOCS"
backup_file ~/Documents/whattodo.txt "whattodo.txt"

log_info "сохраняю список пакетов pacman..."
if pacman -Qeq | tr "\n" " " > "$dest/pkg_list.txt"; then
    log_ok "список пакетов сохранен в pkg_list.txt"
else
    log_error "не удалось сохранить список пакетов"
fi

log_info "создаю README..."
cat <<EOT > "$dest/README.txt"
инструкция для kowk:
1. конфиги из папок кидай в ~/.config/
2. не забудь про fastfetch — теперь твой кастомный конфиг тоже тут!
3. шрифты в ~/.local/share/fonts/ и сделай fc-cache -fv
4. файл zshrc кидай в ~/ и переименовывай в .zshrc (не забудь точку!)
5. цветовые схемы кде закидывать обратно в ~/.local/share/color-schemes/
6. тему telegram закидывать в ~/.config/telegram-desktop/themes/

в файле 'old_system_fetch.txt' лежит инфа о твоем старом арче!

Если не запоминает
sudo ln -s /etc/xdg/menus/arch-applications.menu /etc/xdg/menus/applications.menu
kbuildsycoca6 --noincremental
FOR HYPRLAND / KDE

Exec=env XDG_SESSION_TYPE=x11 vesktop --ozone-platform=x11 (процент)u

Для Niri чтобы Qt-приложения (Dolphin и т.д.) не сбрасывали тему:
  environment {
      QT_QPA_PLATFORM "wayland"
      QT_QPA_PLATFORMTHEME "kde"
      QT_QPA_PLATFORMTHEME_QT6 "kde"
      KDE_FULL_SESSION "true"
  }
(прописать в ~/.config/niri/config.kdl и/или ~/.config/environment.d/niri.conf)

EOT
log_ok "README.txt создан"

log_info "обновляю симлинк latest..."
rm -f "$parent_dir/latest"
if ln -s "$dest" "$parent_dir/latest"; then
    log_ok "симлинк latest указывает на актуальный бэкап"
else
    log_error "не удалось создать симлинк latest"
fi

notify-send "backup" "фулл бэкап завершен!"
log_ok "готово! всё успешно сохранено в $dest"
