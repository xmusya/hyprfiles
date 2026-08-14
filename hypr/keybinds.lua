require("keycodes")
local mainMod     = "SUPER"
local terminal    = "alacritty"
local fileManager = "dolphin"
local browser     = "firefox"

local kriptsInterface = "~/.config/kripts/interface"
local kriptsSystem    = "~/.config/kripts/system"

-- ============ ОСНОВНЫЕ БИНДЫ ============
hl.bind(mainMod .. " + " .. KEY_Q,          hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SUPER_L",    hl.dsp.exec_cmd("pkill fuzzel || fuzzel"), { release = true })
hl.bind(mainMod .. " + " .. KEY_W,          hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + " .. KEY_E,          hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + " .. KEY_S, hl.dsp.exec_cmd("hyprshot -m region -z -o ~/Pictures/Screenshots/"))
hl.bind("Print",                    hl.dsp.exec_cmd(kriptsInterface .. "/screenshot_menu.sh"))
hl.bind(mainMod .. " + " .. KEY_C,          hl.dsp.window.close())
hl.bind(mainMod .. " + " .. KEY_V,          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + " .. KEY_J,          hl.dsp.layout("togglesplit"))
hl.bind("ALT + F4",                 hl.dsp.window.close())

-- ============ КРИПТС (BINDS BY CODE) ============
hl.bind(mainMod .. " + " .. KEY_M,               hl.dsp.exec_cmd(kriptsInterface .. "/powermenu.sh"))
hl.bind(mainMod .. " + " .. KEY_L,               hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + " .. KEY_R,       hl.dsp.exec_cmd(kriptsSystem .. "/waybar_restart.sh"))
hl.bind("CONTROL + SHIFT + code:9",     hl.dsp.exec_cmd("plasma-systemmonitor"))
hl.bind(mainMod .. " + " .. KEY_SEMICOLON, hl.dsp.exec_cmd("rofimoji --selector fuzzel"))
hl.bind(mainMod .. " + End",            hl.dsp.exec_cmd(kriptsInterface .. "/main_menu.sh"))

-- ============ ЗУМ ============
hl.bind(mainMod .. " + equal",                hl.dsp.exec_cmd(kriptsSystem .. "/zoom.sh inc"))
hl.bind(mainMod .. " + minus",                hl.dsp.exec_cmd(kriptsSystem .. "/zoom.sh dec"))
hl.bind(mainMod .. " + CONTROL + " .. KEY_0,  hl.dsp.exec_cmd(kriptsSystem .. "/zoom.sh reset"))
hl.bind(mainMod .. " + " .. KEY_0,            hl.dsp.exec_cmd("hyprctl eval 'hl.config({ cursor = { zoom_factor = 1.0 } })'"))
hl.bind(mainMod .. " + mouse_up",             hl.dsp.exec_cmd(kriptsSystem .. "/zoom.sh inc"))
hl.bind(mainMod .. " + mouse_down",           hl.dsp.exec_cmd(kriptsSystem .. "/zoom.sh dec"))

-- ============ НАВИГАЦИЯ ============
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + " .. KEY_1,     hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + " .. KEY_2,     hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + " .. KEY_3,     hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + " .. KEY_4,     hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + " .. KEY_5,     hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + " .. KEY_6,     hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + " .. KEY_7,     hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. MOUSE_LEFT,  hl.dsp.window.drag(),    { mouse = true })
hl.bind(mainMod .. " + " .. MOUSE_RIGHT, hl.dsp.window.resize(), { mouse = true })

-- ============ ПЕРЕМЕЩЕНИЕ ОКОН (SUPER + ALT + 1-5) ============
hl.bind(mainMod .. " + ALT + " .. KEY_1, hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_2, hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_3, hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_4, hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_5, hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_6, hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(mainMod .. " + ALT + " .. KEY_7, hl.dsp.window.move({ workspace = 7, follow = false }))

-- ============ ЗВУК ============
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"))

-- ============ ФУЛЛСКРИН (ALT + ENTER) ============
hl.bind("ALT + Return", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
