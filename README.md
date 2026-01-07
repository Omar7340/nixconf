# Nixconf

## Hosts

- wsl
- homelab (babel)

## Homelab Deploy

Use nixos-anywhere.

From wsl or any other nix instance:

```sh
    sudo nix run github:nix-community/nixos-anywhere -- --flake .#babel --target-host root@<TARGET-IP>
```

It will use disk-config.nix as disko configuration
