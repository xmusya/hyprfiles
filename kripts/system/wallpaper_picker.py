#!/usr/bin/env python3
"""Wallpaper picker for Hyprland (awww + hyprlock), KDE file dialog."""
import os
import re
import subprocess
import sys

WALLPAPER_DIR = os.path.expanduser(
    "~/.config/hypr/hyprland/matchingwallpapers"
)
HYPRLOCK_CONF = os.path.expanduser("~/.config/hypr/hyprlock.conf")

IMAGE_FILTER = "Images (*.png *.jpg *.jpeg *.webp *.bmp)"


def notify(title, body, icon=None):
    cmd = ["notify-send"]
    if icon:
        cmd += ["-i", icon]
    cmd += [title, body]
    subprocess.run(cmd, capture_output=True)


def pick():
    proc = subprocess.run(
        ["kdialog", "--title", "Wallpaper", "--getopenfilename",
         WALLPAPER_DIR, IMAGE_FILTER],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        sys.exit(1)
    path = proc.stdout.strip()
    return path or None


def set_hyprlock_wallpaper(path):
    with open(HYPRLOCK_CONF) as fh:
        content = fh.read()
    content = re.sub(r"(path\s*=\s*).*", r"\g<1>" + path, content, count=1)
    with open(HYPRLOCK_CONF, "w") as fh:
        fh.write(content)


def apply_wallpaper(path):
    subprocess.run(
        ["awww", "img", "--resize", "crop", "--transition-type", "simple",
         "--transition-duration", "0.6", path],
        capture_output=True,
    )


def main():
    path = pick()
    if path is None:
        sys.exit(1)

    apply_wallpaper(path)
    set_hyprlock_wallpaper(path)

    notify("Wallpaper", os.path.basename(path), icon=path)


if __name__ == "__main__":
    main()
