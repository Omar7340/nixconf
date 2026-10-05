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

- After the first Niri boot, verify real SDDM authentication, the physical 3440×1440/180 Hz output, session services, screen-sharing portal, lock/unlock and actual Steam/Proton games. The nested desktop and SDDM previews check composition, not PAM authentication, physical display or game behavior (see CHANGELOG.md, 2026-10-05 and 2026-10-06, Tower desktop changes).
- Investigate why the Philips/NVIDIA DisplayPort connection reports VRR unavailable before enabling Niri adaptive sync. Keep KDE for HDR until upstream Niri supports the required HDR/color management (see CHANGELOG.md, 2026-10-05, Tower Niri desktop).
- Investigate Tower's Nix store consistency: the Obsidian installation encountered multiple registered but missing dependencies and generated outputs; the Niri build also required restoring `nixos-render-docs`. Targeted repairs allowed both builds to pass, but the earlier broader repair reported an unrepaired `tmpfiles.d` output closure (see CHANGELOG.md, 2026-10-05).
- Ensure `/var/lib/nix-signing/tower-1.sec` is included in the Tower backup and disaster-recovery plan without ever committing it to Git or copying it to Babel.
