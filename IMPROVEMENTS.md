# Improvement Backlog

## Babel

- Remove the full development profile from the Babel host unless local development tools are genuinely required. This will reduce closure size, installation time, update bandwidth, and package attack surface.
- Replace FileBrowser with a maintained alternative. The deployed FileBrowser version reports that the upstream project is archived and will not receive further security fixes. Until replacement, keep it behind Caddy and restricted to trusted LAN and Tailscale clients.
- Decide whether physical data-at-rest protection is required. Full-disk encryption would protect the system and media disks, but a headless server needs a deliberate unlock design such as console entry, initrd SSH, or hardware-backed automatic unlock.
- Remove `discardPolicy = "both"` from the swap partition on the rotational HGST disk unless the hardware is verified to support useful discard behavior.
- Consider removing disk-backed swap in favor of zram, or encrypt swap with an ephemeral key, to reduce the risk of sensitive memory contents persisting on disk.
- Define a stable address strategy for `192.168.1.126`, preferably a router DHCP reservation or a declarative static NetworkManager profile, so AdGuard rewrites cannot become stale after a lease change.
- Decide how remote Tailscale clients should resolve the `*.babel.local` service names. Options include configuring Babel as a tailnet DNS server with an approved `/32` subnet route, or exposing selected services through a deliberate Tailscale-native naming scheme.
- Install Caddy's internal CA certificate on trusted clients, or adopt another certificate strategy, to avoid browser warnings for the private `*.babel.local` HTTPS endpoints.

## Tower and repository

- Investigate the Tower-only Chromium/store evaluation failure seen during repository-wide `nix flake check --no-build`.
- Ensure `/var/lib/nix-signing/tower-1.sec` is included in the Tower backup and disaster-recovery plan without ever committing it to Git or copying it to Babel.
