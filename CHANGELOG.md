# Changelog

Material configuration and deployment changes are recorded here, newest first.

## 2026-09-15

### Tower Tailscale

- Enabled Tailscale declaratively on Tower and opened its UDP transport port in the host firewall.

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
