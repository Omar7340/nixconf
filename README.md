# Nixconf

Multi-host NixOS configuration built with flakes and flake-parts. Module loading is explicit in `modules/default.nix`:

- `base` contains settings shared by every host.
- feature modules provide optional desktop, development, gaming, and multimedia capabilities.
- profiles compose related features, such as the Babel server and homelab stack.
- host directories contain only machine-specific configuration and hardware declarations.

## Hosts

- wsl
- babel (homelab server)
- tower (desktop)

## Homelab Deploy

Use nixos-anywhere.

From wsl or any other nix instance:

```sh
sudo nix run github:nix-community/nixos-anywhere -- --flake .#babel --target-host root@<TARGET-IP>
```

The Babel host imports `modules/nixosModules/hosts/babel/disko.nix` directly.

## Validation

```sh
nix fmt
statix check .
nix flake check --no-build
nix build .#nixosConfigurations.tower.config.system.build.toplevel --no-link
```

Replace `tower` with `wsl` or `babel` to validate another host without activating it.
