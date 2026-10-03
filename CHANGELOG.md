# Changelog

Material configuration and deployment changes are recorded here, newest first.

## 2026-10-03

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
