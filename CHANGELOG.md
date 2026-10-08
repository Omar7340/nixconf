# Changelog

Material configuration and deployment changes are recorded here, newest first.

## 2026-10-08

### Tower Hyprland migration

- Replaced Tower's default Niri session with Hyprland 0.56.2 using native Lua configuration, UWSM session management, integrated Xwayland and the Hyprland screen-sharing portal. Retained KDE as a boot specialization, the existing NVIDIA driver and 3440×1440/180 Hz monitor configuration.
- Carried over wallpaper/palette controls, GTK/Qt/editor colors, custom Waybar settings, notifications, keyring, lock/idle behavior, clipboard history, screenshots, brightness controls and French AZERTY shortcuts. Existing wallpaper and palette state remains in its original directory; custom bar modules are adapted without overwriting user files. Niri layout overrides are not imported. Password-manager windows remain excluded from screen sharing. Launcher applications use separate UWSM scopes so bar restarts do not stop them.
- Removed the proposed Steam SDL XRandR workaround before activation. Steam and its games retain their original display-mode handling. Brave's saved core reports a fatal GPU-process failure; this differs from Steam's SDL3 segfault, and a common display trigger remains unconfirmed.
- Validation: Alejandra, Statix, the x86_64-linux flake check and full Tower/Hyprland plus KDE builds passed. The complete Lua configuration and generated fallback palette passed Hyprland's parser. A nested instance exposed its monitor and reported no configuration errors, but the nested Wayland backend logged a configure/buffer protocol error; physical display behavior, login, screen sharing and games remain first-boot checks. Repaired the registered-but-missing `isl-0.20` store dependency encountered during the build.
- Deployment: installed Tower generation 213 and its KDE specialization with `nh os boot --no-nom -R path:/etc/nixos#tower`. Hyprland/UWSM is the default for the next boot. The running Niri generation 211, SDDM and Tailscale remain active; no reboot or session termination was performed.

## 2026-10-06

### Tower responsive monitor brightness

- Replaced repeated display discovery, synchronous reads and queued brightness commands with a cached I2C bus and brightness target. One background writer coalesces rapid key/scroll requests and uses direct absolute DDC writes without per-write readback; idle status checks reconcile physical OSD changes once per minute.
- Made the Waybar percentage refresh once per second from the cache, removed repeated success notifications, and kept the brightness picker outside the state lock.
- Validation: Alejandra, Statix, the x86_64-linux flake check and full Tower/Niri plus KDE builds passed. A real three-request burst submitted in 38 ms and reached the combined hardware target in 390 ms; independent DDC readback verified the result and restoration of the original brightness.
- Deployment: activated Tower generation 211 without restarting Niri or SDDM, updated the existing custom Waybar brightness interval and verified both the bar and display manager are active. Persistent monitor selection also works without the new session environment variable; physical OSD changes can be refreshed immediately with `monitor-brightness sync`.

### Neovim wallpaper colors and Tower monitor brightness

- Connected both the installed Nixvim editor and standalone Neovim wrapper to Niri's data-only wallpaper palette, including editor UI, syntax, Telescope and the automatic status-line theme. Open editors poll for palette changes and expose `:WallpaperTheme`; other desktops retain their configured theme. Shared editor modules are evaluated for Tower, WSL and Babel.
- Added user-accessible DDC/CI brightness control for Tower's Philips 34M2C3500L, using existing I2C permissions. Super+F5/F6 and brightness media keys adjust the actual monitor by 5%; Super+Shift+B and the Waybar widget offer percentage selection. Concurrent adjustments are serialized; values respect the monitor's reported range.
- Validation: Alejandra, Statix, the x86_64-linux flake check, Niri configuration validation and the full Tower/Niri plus KDE build passed. Verified actual Neovim highlights and automatic refresh after atomic palette replacement. As the desktop user, detected DDC on `/dev/i2c-4`, read 100% brightness, changed it to 95%, verified it and restored 100%.
- Deployment: activated Tower generation 210 without restarting Niri or SDDM; added the brightness widget to the existing custom Waybar configuration with a backup, preserving its other settings. Reopen existing Neovim instances to load the new integration. WSL and Babel build attempts encountered unrelated registered-but-missing store dependencies; repair-mode evaluation restored the missing Babel derivation, but full builds remain unverified due to missing `cfg-if` and `udev-rules` paths.

### Tower French AZERTY shortcuts

- Replaced QWERTY-oriented brackets, shifted slash, comma/period and minus/equal bindings with accessible French AZERTY shortcuts. Super+F1 opens help, Super+F2 opens customization, Super+Alt+Left/Right groups windows, Super+S and Super+Shift+D stack/detach windows, and Super+Ctrl+Alt+arrows resize them.
- Extended the unshifted French number row to ten workspaces using `& é " ' ( - è _ ç à`, with Ctrl to move the current column. Retained numeric aliases for the optional US layout and updated the shortcut reference.
- Validation: Niri configuration validation (including the user's generated palette), Alejandra, Statix, the x86_64-linux flake check and the complete Tower build passed. Verified the installed home configuration matches the repository.
- Deployment: activated Tower generation 209 in the current Niri session, without restarting the display manager.

### Tower live wallpaper-theme verification

- Verified the first physical Niri session uses the saved HDD wallpaper and generated palette in the compositor, Waybar, launcher and terminal configuration; SDDM's shared JSON matches the current desktop palette.
- Fixed competing Mako daemons: D-Bus activation now uses the same wallpaper-themed systemd service as the Niri session. Preserved `niri-notifications.service` as an alias. Previously the unthemed upstream daemon acquired the notification bus name first.
- Moved the generated GTK color import after preserved CSS so stale KDE color imports cannot override the wallpaper palette.
- Changed palette refresh to restart the running Waybar service rather than signal an in-process CSS reload after observing a Waybar core dump in the physical session.
- Validation: Alejandra, Statix, the x86_64-linux flake check and complete Tower build passed. Verified live palette paths, GTK theme/font settings, matching SDDM JSON, and the physical 3440×1440/180 Hz output. After activation, both notification service names resolve to the same themed Mako process, with no restart loop; palette restoration and Waybar restart succeeded.
- Deployment: activated Tower generation 208 without restarting SDDM or Niri, preserving the current wallpaper and session. GTK/Qt applications already open may need restarting to pick up their new settings.

### Tower coherent login and application theme

- Replaced the Breeze login theme with a custom Qt 6 SDDM greeter for both Niri and KDE boot configurations. It reads the selected wallpaper and Matugen palette from a shared cache, with consistent JetBrains Mono typography, authentication errors, session selection and power controls.
- Added unprivileged wallpaper/palette publication into a desktop-owner-writable, SDDM-readable setgid directory. Only PNG/JSON data are shared; theme code remains immutable. The HDD and private home directory do not need to be accessible to SDDM, and no root image decoder or sudo synchronization helper was introduced.
- Matched the lock-screen wallpaper, GTK settings, Qt 5/6 palettes and KDE application colors to the desktop. Unified Stylix fonts with the existing desktop/terminal font and preserved unrelated application settings with first-change backups.
- Validation: Alejandra, Statix, the x86_64-linux flake check and complete Tower/Niri plus KDE specialization builds passed. QML lint and SDDM test-mode rendering passed in a nested Wayland session; saved `docs/sddm-preview.png`. Tested real-image palette generation and application settings, seeded the user's saved wallpaper cache, and verified SDDM can read the PNG/JSON with owner `kage`, group `sddm` and mode 0640.
- Deployment: installed generation 207 for the next boot, retaining default Niri and the KDE specialization. The running KDE session remains on generation 205; display manager and Tailscale are active with no failed system units. Real SDDM authentication remains a first-login check; Limine/Plymouth and application-internal themes remain separate from the runtime palette.

## 2026-10-05

### Tower Niri desktop and KDE boot specialization

- Made Niri the default Tower desktop and added an inherited `KDE` specialization to Limine. Each boot configuration selects its own SDDM session; shared hardware, gaming, secrets and storage settings are retained. Other hosts and locked inputs are unchanged.
- Replaced the obsolete Noctalia-dependent Niri configuration with independent Fuzzel, Waybar, Mako, Awww, Swaylock and Swayidle components supervised only during the Niri session. Added Polkit, keyring, PipeWire audio, screen-sharing portals, network tray, text clipboard history, screenshots, launch/terminal shortcuts and a confirmed power menu.
- Matched Tower's detected Philips Evnia 34M2C3500L on DP-2 to 3440×1440 at 180 Hz and integer scaling, with ultrawide column presets and French/US layouts including AZERTY workspace keys.
- Added a recursive wallpaper picker for `/mnt/HDD/Wallpapers` and Matugen palettes for the launcher, bar, notifications, Niri accents, lock screen, GTK and new Kitty windows. Cache the selected wallpaper for HDD outages, render templates before replacing generated files, and expose persistent user-owned settings, CSS, templates and Niri overrides through the customization menu.
- Retained NVIDIA modesetting, Steam, GE-Proton, GameMode, MangoHud and optional Gamescope; added on-demand Xwayland Satellite and fullscreen Steam game rules. HDR remains available through KDE; VRR is not enabled because the current connection reports it unavailable. Clipboard history is local and can be cleared with `cliphist wipe`.
- Validation: Alejandra, Statix, the x86_64-linux flake check and complete Tower/Niri plus KDE specialization builds passed. Tested real-image palette generation, no-wallpaper fallback, Fuzzel parsing, the final desktop wrapper, notifications and Waybar in an isolated nested Niri session; verified on-demand Xwayland Satellite with a real X11 application. Saved a preview in `docs/niri-desktop-preview.png`. Restored the missing `nixos-render-docs` dependency encountered during the build.
- Deployment: installed Tower generation 206 with `nh os boot`, selecting Niri for the next boot and retaining the KDE specialization. The current KDE session remains on generation 205; display manager and Tailscale are active, and no system units are failed. Physical monitor behavior, PAM unlock, screen sharing and actual games require verification after the next Niri login.

### Tower Obsidian

- Added Obsidian to the shared office package list, currently used by Tower.
- Validation: Alejandra, Statix, the x86_64-linux flake check, and the full Tower build passed. Restored missing Nix store build dependencies and generated outputs encountered during the build. Activated Tower generation 205; Obsidian 1.13.7 is available, display manager and Tailscale are active, and no system units are failed.

## 2026-10-03

### Flake inputs

- Recorded the existing locked-input updates for Tower, Babel, and WSL, including Nixpkgs, Disko, Hjem, NixOS-WSL, editor modules, Stylix, Sops, VPN confinement, and supporting dependencies. No encrypted secrets changed.
- Validation: Alejandra, Statix, the x86_64-linux flake check, and complete Tower, Babel, and WSL builds passed with these locked inputs. Tower is running generation 204; Babel and WSL were built without activation.

### Tower OpenRGB startup

- Fixed the animation client exiting successfully when OpenRGB has not detected devices during boot. It now fails and retries after five seconds, so lighting can start once detection completes.
- Required the OpenRGB server and propagated server restarts to the animation client. Enabled unbuffered client logs for startup diagnostics.
- Diagnosis: the boot journal showed the client reporting no devices and deactivating successfully before a manual restart.
- Validation: Alejandra, Statix, the x86_64-linux flake check, the complete Tower build, and a simulated empty-device startup passed. Activated on Tower (generation 204); both services are running and the client journal confirms the Fill effect started. Boot-time keyboard lighting still needs confirmation after a reboot.

### Terminal environment

- Activated the terminal environment on Tower with `nh os switch --no-nom --no-update-lock-file -R path:/etc/nixos#tower`. Disabled Stylix's Fish palette injection in `terminal/emulator.nix` after a live smoke check exposed it overriding Kitty's Tokyo Night colors. Confirmed the active generation, healthy display manager/Tailscale, no failed system units, available Fish functions, Atuin's Ctrl-R binding, and `/etc/atuin` configuration in a fresh login environment.
- Added a shared native NixOS terminal feature for Tower, Babel, and WSL: Fish, Starship, local-only Atuin history, zoxide, fzf, fd, ripgrep, bat, eza, jq, Yazi, Lazygit, btop, delta, and on-demand Zellij. No Home Manager or additional configuration framework was introduced.
- Consolidated terminal tools out of the development package list. Tower now uses a configured Tokyo Night Kitty; removed Alacritty and updated Niri launch bindings. Babel no longer installs Kitty through the development profile.
- Kept Bash as the login shell; Kitty and Zellij explicitly launch Fish. Preserved Neovim as the editor on Tower/Babel and supplied a Nano fallback on WSL. Corrected Helix's command shell to Bash.
- Added fuzzy navigation/editor functions, visible Git abbreviations, `terminal-help`, and explicit `nixos-workflow` commands for checks, formatting, builds, diffs, generations, and activation. Removed the generic `rebuild` alias; activation requires a named host matching the local hostname.
- Disabled Atuin synchronization, update checks, daemon, and AI shortcut. Git uses delta without replacing normal Git commands. Existing lock-file changes and encrypted secrets were left untouched.
- Added the terminal README with file responsibilities, configuration limitations, keyboard shortcuts, and migration notes.
- Validation: Alejandra, Statix, full flake check for x86_64-linux, and complete Tower/Babel/WSL system builds passed. Generated Fish syntax, Starship context rendering, Kitty config parsing, Zellij wrapper/config, help output, and workflow host rejection were checked. The previously recorded Tower evaluation failure no longer reproduced, so its backlog item was removed. Tower activation was subsequently verified as recorded above; graphical session appearance has not been inspected.

## 2026-09-15

### Tower Chiaki-ng

- Added Chiaki-ng to Tower's gaming packages for PlayStation Remote Play.

### Tower Tailscale

- Enabled Tailscale declaratively on Tower and opened its UDP transport port in the host firewall.
- Mapped Babel's private service hostnames to its Tailscale address and trusted Babel's Caddy root CA, allowing Brave to open the homelab HTTPS endpoints without DNS or certificate warnings.

### Tower boot experience

- Replaced systemd-boot with Limine on Tower, using a styled Tokyo Night menu, a three-generation retention limit, and a Memtest86+ chainload entry.
- Enabled quieter kernel and initrd output so Plymouth remains visible while preserving the emergency boot shell.
- Moved the complete NVIDIA display stack into the initrd to reduce late framebuffer mode changes during startup.

### Babel homelab deployment

- Installed NixOS on Babel's HGST system disk and provisioned the Samsung T5 as `/mnt/media` with Disko. The Kingston Ventoy installer USB was identified by its persistent device ID and excluded from all writes.
- Deployed AdGuard Home, Caddy, FileBrowser, Homepage, Jellyfin, OpenSSH, nftables, and Tailscale.
- Restricted SSH, DNS, HTTP, and HTTPS ingress to `192.168.1.0/24` and Tailscale's `100.64.0.0/10`; retained the public Tailscale UDP transport port.
- Enrolled Babel in Tailscale as `babel-1.tail36dedd.ts.net` with address `100.98.91.45`.
- Corrected the homelab DNS address to `192.168.1.126` and removed the `systemd-resolved` port conflict so AdGuard can serve DNS directly.
- Isolated FileBrowser to `/mnt/media/library` and corrected shared media permissions while keeping Jellyfin state private.
- Removed the inactive Mullvad WireGuard secret and disabled Transmission with its VPN confinement, preventing accidental torrent traffic outside a VPN.
- Restricted EFI mount permissions with `umask=0077`.
- Added key-only remote administration for Babel with passwordless sudo for the wheel account.
- Created a Tower-only Nix signing key, configured Tower to sign closures, and configured Babel to trust Tower's public key. Remote deployments now transfer signed Nix store closures without copying the repository to Babel.
- Validated the Babel build with Alejandra and Statix, built the full Babel system closure, confirmed all declared services active, confirmed no failed units, and tested all four HTTPS reverse-proxy endpoints.

### Validation note

- Repository-wide `nix flake check --no-build` successfully evaluated Babel but encountered an unrelated Tower-only Chromium/store evaluation error. The Babel system was built and deployed independently.
