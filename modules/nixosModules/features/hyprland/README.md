# Tower Hyprland

Hyprland starts through UWSM with integrated Xwayland and the Hyprland screen-sharing portal. KDE remains available as a boot specialization.

Super+Return/T opens Kitty, Super+Space/A/D opens Fuzzel, Super+B opens Brave, Super+Shift+S opens Steam, Super+Q closes a window, Super+V toggles floating, Super+F toggles fullscreen. Super+arrows focuses windows and Super+Shift+arrows moves them. Super plus the unshifted French number row selects workspaces 1–10; add Ctrl to move a window there. Super+mouse drag moves or resizes windows.

Super+W picks a wallpaper, Super+Shift+W picks randomly, Super+L locks, Super+Shift+C opens clipboard history, Super+F5/F6 changes monitor brightness, Super+Shift+B opens the brightness picker, and Super+Shift+E opens the confirmed power menu. Print selects a screenshot region; Ctrl+Print captures the output. Screenshots are saved under `~/Pictures/Screenshots` and copied to the clipboard.

Existing wallpaper, palette, GTK/Qt and editor state is retained under `~/.local/state/niri-desktop` for compatibility. Existing settings and custom bars remain under `~/.config/niri-desktop`; bar modules are adapted at launch without overwriting the original. Niri layout overrides are not imported. Hyprland overrides live in `~/.config/hypr/local.lua`; run `hyprctl reload` after editing.

Session components are bound to `wayland-session@hyprland.desktop.target`; inspect `hyprland-{theme,wallpaper,waybar,idle,polkit}` and `mako` user services. Use `hyprctl configerrors`, `hyprctl monitors`, and `systemctl --user status xdg-desktop-portal-hyprland` to check the session.
