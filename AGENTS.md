# Repository Guidelines

## Project Structure & Module Organization

This repository is a multi-host NixOS flake. `flake.nix` declares inputs, while `modules/default.nix` explicitly exports modules and composes the `wsl`, `tower`, and `babel` hosts. Put shared settings in `modules/nixosModules/base/`, optional capabilities in `modules/nixosModules/features/`, reusable profiles in `modules/nixosModules/profiles/`, and program wrappers in `modules/wrappedPrograms/`. Keep application-specific configuration beside its module, such as Neovim Lua files under `modules/wrappedPrograms/neovim/config/`. Encrypted material belongs in `secrets/`; never commit plaintext credentials.

## Build, Test, and Development Commands

- `nix flake check` evaluates the flake and runs any declared checks.
- `nix build .#nixosConfigurations.tower.config.system.build.toplevel` builds a host without activating it; replace `tower` with `wsl` or `babel`.
- `sudo nixos-rebuild switch --flake .#tower` builds and activates a host configuration. Run this only on the intended machine.
- `alejandra .` formats Nix files consistently.
- `statix check .` reports common Nix antipatterns.
- `nix flake update` refreshes locked inputs; review and commit the resulting `flake.lock` changes intentionally.

## Coding Style & Naming Conventions

Use Alejandra formatting and two-space indentation in Nix files. Prefer small, focused modules with descriptive lowercase filenames (for example, `features/homelab/jellyfin.nix`). Use camelCase for Nix option names and follow existing upstream option naming when configuring services. Keep host-only hardware and disk settings within the relevant host directory rather than reusable modules.

## Testing Guidelines

There is no separate test framework or coverage target. Before submitting changes, run `alejandra .`, `statix check .`, and `nix flake check`. Build every affected host configuration. For service or hardware changes, activate first on the target host and verify the relevant service with `systemctl status <service>`.

## Commit & Pull Request Guidelines

Recent commits use short, imperative summaries such as `flake update` and `+ kdeconnect`. Keep subjects concise and name the affected feature or host; avoid mixing unrelated configuration changes. Pull requests should explain the motivation, list affected hosts, summarize validation commands, and call out input-lock or encrypted-secret changes. Include screenshots only for visible desktop, editor, or theme changes.
