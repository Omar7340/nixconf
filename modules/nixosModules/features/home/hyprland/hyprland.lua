-- Native Hyprland 0.56 Lua configuration.
dofile("/etc/hyprland-desktop/monitor.lua")
hl.on("hyprland.start", function()
    if os.getenv("UWSM_FINALIZE_VARNAMES") then hl.exec_cmd("uwsm finalize") end
end)
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.config({
    input = {kb_layout = "fr,us", kb_options = "grp:alt_shift_toggle", numlock_by_default = true, follow_mouse = 1},
    general = {gaps_in = 6, gaps_out = 12, border_size = 3, layout = "dwindle"},
    dwindle = {preserve_split = true},
    decoration = {rounding = 12, shadow = {enabled = true, range = 25, color = 0x55000000}},
    misc = {disable_hyprland_logo = true, force_default_wallpaper = 0},
    xwayland = {force_zero_scaling = true},
})
local function optional(path)
    local f = io.open(path)
    if f then f:close(); dofile(path) end
end
local home = os.getenv("HOME")
optional(home .. "/.local/state/niri-desktop/theme/hyprland.lua")
optional(home .. "/.config/hypr/local.lua")
local function exec(key, command, options)
    hl.bind(key, hl.dsp.exec_cmd(command), options)
end
exec("SUPER + RETURN", "uwsm app -- kitty")
exec("SUPER + T", "uwsm app -- kitty")
exec("SUPER + E", "uwsm app -- kitty yazi")
for _, key in ipairs({"SPACE", "A", "D"}) do exec("SUPER + " .. key, "hyprland-launcher") end
exec("SUPER + B", "uwsm app -- brave")
exec("SUPER + SHIFT + S", "uwsm app -- steam")
exec("SUPER + L", "hyprland-lock")
exec("SUPER + W", "hyprland-desktop pick")
exec("SUPER + SHIFT + W", "hyprland-desktop random")
exec("SUPER + SHIFT + C", "hyprland-clipboard")
exec("SUPER + SHIFT + N", "makoctl mode -t do-not-disturb")
exec("SUPER + F1", "uwsm app -- kitty nvim /etc/hyprland-desktop/README.md")
exec("SUPER + F2", "hyprland-desktop settings")
exec("SUPER + SHIFT + E", "hyprland-desktop power")
exec("CTRL + ALT + DELETE", "hyprland-desktop power")
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({action = "toggle"}))
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen())
for _, direction in ipairs({"left", "right", "up", "down"}) do
    hl.bind("SUPER + " .. direction, hl.dsp.focus({direction = direction}))
    hl.bind("SUPER + SHIFT + " .. direction, hl.dsp.window.move({direction = direction}))
end
local keys = {"ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "minus", "egrave", "underscore", "ccedilla", "agrave"}
for i, key in ipairs(keys) do
    hl.bind("SUPER + " .. key, hl.dsp.focus({workspace = i}))
    hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({workspace = i}))
end
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {mouse = true})
for key, cmd in pairs({
    XF86AudioRaiseVolume = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
    XF86AudioLowerVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
    XF86AudioMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    XF86AudioMicMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    XF86AudioPlay = "playerctl play-pause", XF86AudioPrev = "playerctl previous", XF86AudioNext = "playerctl next",
    XF86MonBrightnessUp = "monitor-brightness up", XF86MonBrightnessDown = "monitor-brightness down",
}) do exec(key, cmd, {locked = true, repeating = true}) end
exec("SUPER + F5", "monitor-brightness down")
exec("SUPER + F6", "monitor-brightness up")
exec("SUPER + SHIFT + B", "monitor-brightness menu")
exec("PRINT", "hyprland-screenshot region")
exec("CTRL + PRINT", "hyprland-screenshot output")
hl.window_rule({name = "steam-games", match = {class = "^steam_app_[0-9]+$"}, fullscreen = true, rounding = 0})
hl.window_rule({name = "steam-dialogs", match = {class = "^(steam|Steam)$", title = "^(Friends List|Steam Settings)$"}, float = true})
hl.window_rule({name = "picture-in-picture", match = {title = "^(Picture-in-Picture|Mode PIP.*)$"}, float = true})
hl.window_rule({name = "password-managers", match = {class = "^(org\\.keepassxc\\.KeePassXC|org\\.gnome\\.World\\.Secrets|Bitwarden)$"}, no_screen_share = true})
