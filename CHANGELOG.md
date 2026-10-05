# Changelog

Material configuration and deployment changes are recorded here, newest first.

## 2026-10-06

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
