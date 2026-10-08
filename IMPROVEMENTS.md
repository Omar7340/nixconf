# Improvement Backlog

## Babel

- Remove the full development profile from the Babel host unless local editors and Wireshark are genuinely required. The terminal toolkit is now independent of that profile, and Kitty has been removed from Babel (see CHANGELOG.md, 2026-10-03).
- Replace FileBrowser with a maintained alternative. The deployed FileBrowser version reports that the upstream project is archived and will not receive further security fixes. Until replacement, keep it behind Caddy and restricted to trusted LAN and Tailscale clients.
- Decide whether physical data-at-rest protection is required. Full-disk encryption would protect the system and media disks, but a headless server needs a deliberate unlock design such as console entry, initrd SSH, or hardware-backed automatic unlock.
- Remove `discardPolicy = "both"` from the swap partition on the rotational HGST disk unless the hardware is verified to support useful discard behavior.
- Consider removing disk-backed swap in favor of zram, or encrypt swap with an ephemeral key, to reduce the risk of sensitive memory contents persisting on disk.
- Define a stable address strategy for `192.168.1.126`, preferably a router DHCP reservation or a declarative static NetworkManager profile, so AdGuard rewrites cannot become stale after a lease change.
- Decide how remote Tailscale clients should resolve the `*.babel.local` service names. Options include configuring Babel as a tailnet DNS server with an approved `/32` subnet route, or exposing selected services through a deliberate Tailscale-native naming scheme.
- Install Caddy's internal CA certificate on trusted clients, or adopt another certificate strategy, to avoid browser warnings for the private `*.babel.local` HTTPS endpoints.

## Tower and repository

- Diagnose the October 8 DP-2 disconnects and loss of the 180 Hz mode, and investigate Brave's fatal GPU-process failure and Waybar's GLib dispatcher crash at 19:50. The unactivated Steam workaround was removed during the Hyprland migration; verify physical reconnect behavior and Brave/Steam stability under Hyprland (see CHANGELOG.md, 2026-10-08).

- Repair the remaining missing store dependencies blocking full WSL and Babel builds (`cfg-if-1.0.4` and `udev-rules`). Repair-mode evaluation restored a missing Babel Hjem derivation during the Neovim/brightness work; Tower built and activated successfully (see CHANGELOG.md, 2026-10-06).
- After the first Hyprland boot, verify SDDM authentication, the physical 3440×1440/180 Hz output, UWSM session services, screen sharing, lock/unlock and Steam/Proton games. Parser and nested checks do not establish physical display or game stability (see CHANGELOG.md, 2026-10-08, Tower Hyprland migration).
- Investigate why the Philips/NVIDIA DisplayPort connection reports VRR unavailable before enabling adaptive sync under Hyprland. Validate Hyprland HDR/color management on the physical monitor before replacing KDE for HDR use (see CHANGELOG.md, 2026-10-08, Tower Hyprland migration).
- Investigate Tower's Nix store consistency: the Obsidian installation encountered multiple registered but missing dependencies and generated outputs; the Niri build also required restoring `nixos-render-docs`. Targeted repairs allowed both builds to pass, but the earlier broader repair reported an unrepaired `tmpfiles.d` output closure (see CHANGELOG.md, 2026-10-05).
- Ensure `/var/lib/nix-signing/tower-1.sec` is included in the Tower backup and disaster-recovery plan without ever committing it to Git or copying it to Babel.
