# Tower desktop

Tower boots into the default **Niri** configuration. In Limine, expand the latest generation and select **KDE** for Plasma; **Default** is Niri. The login screen defaults to the desktop selected at boot. Reboot to change the system specialization. Previous generations remain rollback choices.

The Philips Evnia 34M2C3500L on DP-2 uses 3440×1440 at 180 Hz, scale 1. The RTX 3070 driver, modesetting and early NVIDIA modules remain enabled. Layouts on the ultrawide default to half-width columns with one-third and two-thirds presets. Monitor configuration lives beside Tower hardware in `hosts/tower/niri-outputs.kdl`.

## Everyday controls

| Shortcut | Action |
| --- | --- |
| Super+Space / Super+D / Super+A | Search installed applications with Fuzzel |
| Super+Return / Super+T | Kitty with Fish |
| Super+B | Brave |
| Super+E | Yazi file manager |
| Super+W | Search wallpapers by filename |
| Super+Shift+W | Random wallpaper and matching palette |
| Super+Shift+Comma | Desktop customization menu |
| Super+Shift+C | Search text clipboard history |
| Super+Shift+N | Toggle notification Do Not Disturb |
| Super+Shift+S | Steam |
| Super+L | Lock |
| Super+O | Overview |
| Super+Q | Close window |
| Super+arrows | Focus windows |
| Super+Ctrl+arrows | Move windows |
| Super+1…9 | Workspace (physical number row on AZERTY) |
| Super+Ctrl+1…9 | Move column to workspace |
| Super+R | Cycle column widths |
| Super+F | Maximize column |
| Super+Shift+F | Fullscreen window |
| Super+V | Toggle floating |
| Print / Ctrl+Print / Alt+Print | Area / screen / window screenshot |
| Super+Shift+E / Ctrl+Alt+Delete | Power menu with confirmation |
| Super+F1 | Show all shortcuts |
| Alt+Shift | Switch French / US keyboard layout |

Screenshots are saved under `~/Pictures/Screenshots`. Audio and media keys work; click the volume widget for device selection. The tray includes NetworkManager and supported running applications. Lock after 10 idle minutes, display sleep after 15; idle inhibitors from games/video are honored. The system also locks before suspend.

## Customize without rebuilding

Open Super+Shift+Comma. It creates editable files only when missing:

- `~/.config/niri/local.kdl`: Niri overrides, watched and reloaded automatically. Add output, input, layout, window rules or binds here; later settings override the base configuration. Validate with `niri validate`.
- `~/.config/niri-desktop/settings.toml`: wallpaper folder, dark/light mode, Material palette scheme, contrast and transition. Run `niri-desktop init` after editing.
- `~/.config/niri-desktop/waybar.json`: bar modules and click actions. Restart with `systemctl --user restart niri-waybar`.
- `~/.config/niri-desktop/waybar.css`: bar geometry, fonts and appearance. Apply with `niri-desktop init`.
- `~/.config/niri-desktop/templates/`: optional Matugen template overrides. Copy defaults from `/etc/niri-desktop/templates`, edit, and run `niri-desktop init`. Color keywords use `{{colors.primary.default.hex}}` and other Material roles.
- `~/.config/niri-desktop/fuzzel.ini`: optional full launcher override. Copy the generated palette from `~/.local/state/niri-desktop/theme/fuzzel.ini`; remove the override to resume automatic launcher colors.

Default files are in `/etc/niri-desktop/`. User overrides and generated state survive rebuilds; the managed `~/.config/niri/config.kdl` comes from the repository. Existing personal `local.kdl` is never overwritten. No Noctalia or monolithic shell is installed.

Wallpapers are discovered recursively in `/mnt/HDD/Wallpapers` (PNG, JPEG, WebP). Use `niri-desktop apply '/path/to/image.jpg'` for an exact file. Matugen generates a contrast-aware palette for Fuzzel, Waybar, Mako, Niri accents, Swaylock, GTK and newly opened Kitty windows. ANSI terminal colors retain their semantic colors. Already-open Kitty windows retain their previous palette. The last wallpaper is cached on the system disk so an unavailable HDD does not prevent login; without any wallpaper the desktop uses a blue fallback. Large wallpaper directories are searched by filename rather than generating hundreds of thumbnails.

The custom SDDM login screen shares the selected wallpaper, Material colors and JetBrains Mono font in both boot configurations. Wallpaper changes publish a normalized PNG and palette JSON to `/var/lib/niri-greeter`; the directory is writable by the desktop owner and readable by SDDM. The greeter code stays immutable in the Nix store, and no root helper or passwordless sudo is needed. The next login screen uses the most recently selected wallpaper, even if the HDD is unavailable. The lock screen uses a darkened copy of the same wallpaper.

GTK and Qt 5/6 applications share the palette, Papirus icons and JetBrains Mono font. Qt uses qt5ct/qt6ct with Fusion; KDE applications also receive a `NiriWallpaper` color scheme through `kdeglobals`. Existing configuration keys are preserved, and first-change backups have the suffix `.before-niri-theme`. Managed symlinks are left untouched. Restart applications to load new colors. These user settings also affect applications in KDE. Application-internal themes and the build-time Limine/Plymouth theme remain separate.

Text clipboard history is local on disk and can include sensitive copied text: run `cliphist wipe` to clear it. Disable `niri-clipboard.service` with a user mask if you do not want history.

## Gaming and screen sharing

Launch Steam normally. Niri 26.04 starts xwayland-satellite 0.8.3 on demand for X11 games and applications; do not start a second satellite or set DISPLAY manually. Native integer output scaling keeps games at 3440×1440. Proton games identifying as `steam_app_*` open fullscreen. Super+Shift+F makes any other game fullscreen. Steam's friend list and settings float.

Existing Proton GE, GameMode, MangoHud, Gamescope and 32-bit NVIDIA support are retained. Optional per-game launch options:

- `gamemoderun %command%` for GameMode.
- `mangohud gamemoderun %command%` for performance monitoring.
- `gamescope -f -W 3440 -H 1440 -- %command%` when a particular game benefits from a nested compositor. Gamescope is optional and must be tested per game, especially on NVIDIA.

Proton Experimental is a good normal choice; select the installed GE tool for games that need it. Native Wine Wayland is not forced globally. Anti-cheat and individual game compatibility remain game-dependent.

Niri's stable release does not provide the HDR/color-management experience of your current KDE session; use the KDE boot entry for HDR. KScreen currently reports VRR incapable on this NVIDIA/monitor connection. Check `niri msg outputs` after logging in; only enable `variable-refresh-rate on-demand=true` in the DP-2 output if support is reported. This configuration does not claim working VRR or HDR.

The GNOME screen-cast portal and PipeWire handle sharing; GTK handles file dialogs. Select the desired monitor/window in the portal dialog. Authentication uses a Polkit agent, and secrets use GNOME Keyring.

## Troubleshooting

Run `niri validate`, `niri msg outputs`, and `systemctl --user status niri-{wallpaper,theme,waybar,notifications,polkit,idle}`. Logs: `journalctl --user -b -u niri.service -u niri-theme.service -u niri-waybar.service`. Reload themes with `niri-desktop init`. Services are bound to the Niri session and stop at logout; KDE uses its own desktop components.

Upstream references: https://niri-wm.github.io/niri/Configuration:-Include.html , https://niri-wm.github.io/niri/Xwayland.html , https://iniox.github.io/matugen/ .
