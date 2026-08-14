#!/usr/bin/env bash
# Запуск wine-игры в изолированной песочнице (bubblewrap)
# Использование: sandbox-run.sh <WINEPREFIX> <ПАПКА_ИГРЫ> <exe>

PREFIX="$1"
dir="$2"
exe="$3"
RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

[ -z "$PREFIX" ] || [ -z "$dir" ] || [ -z "$exe" ] && {
    echo "usage: $0 <WINEPREFIX> <GAME_DIR> <exe>"
    exit 1
}

cd "$dir" || exit 1

exec bwrap \
    --die-with-parent \
    --unshare-net --unshare-ipc --unshare-pid --unshare-uts \
    --new-session \
    --ro-bind /usr /usr \
    --ro-bind /lib /lib \
    --ro-bind /lib64 /lib64 \
    --ro-bind /bin /bin \
    --ro-bind /sbin /sbin \
    --ro-bind /etc /etc \
    --dev /dev \
    --dev-bind /dev/dri /dev/dri \
    --dev-bind /dev/input /dev/input \
    --proc /proc \
    --ro-bind /sys /sys \
    --tmpfs /tmp \
    --ro-bind /tmp/.X11-unix /tmp/.X11-unix \
    --bind "$RUNTIME" "$RUNTIME" \
    --ro-bind "$HOME/.local/share/fonts" "$HOME/.local/share/fonts" \
    --bind "$PREFIX" "$PREFIX" \
    --ro-bind "$dir" "$dir" \
    env WINEPREFIX="$PREFIX" \
    sh -c 'exec gamemoderun wine "$1"' sh "$exe"
