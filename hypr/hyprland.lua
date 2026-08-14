require("monitors")
require("keybinds")
require("visuals")


-- ============ ОКРУЖЕНИЕ ============
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- ============ БАЗОВЫЙ КОНФИГ ============
hl.config({
    input = {
        kb_layout          = "us,ru",
        kb_options         = "grp:alt_shift_toggle",
        follow_mouse       = 1,
        sensitivity        = -1.0,
        accel_profile      = "adaptive",
        resolve_binds_by_sym = true,
        -- СКМ + движение мыши = скролл (scroll_factor замедляет)
        scroll_method      = "on_button_down",
        scroll_button      = 274,
        scroll_factor      = 0.2,
    },
    misc = {
        middle_click_paste = false,
    },
    general = {
        gaps_in     = 2,
        gaps_out    = 3,
        border_size = 2,
        col = {
            active_border   = "rgba(a7c5fcee)",
            inactive_border = "rgba(8e9099aa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding           = 0,
        active_opacity     = 1,
        inactive_opacity   = 1,
        fullscreen_opacity = 1.0,
        blur = {
            enabled           = true,
            size              = 2,
            passes            = 2,
            new_optimizations = true,
            xray              = false,
            noise             = 0.0,
            contrast          = 1.0,
            brightness        = 1.2,
        },
    },
    animations = { enabled = true },
})

-- ============ АВТОЗАПУСК ============
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("pkill kded6 || pkill kded5")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww restore")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 22")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("sleep 2 && waybar")
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("nm-applet --indicator")
end)
