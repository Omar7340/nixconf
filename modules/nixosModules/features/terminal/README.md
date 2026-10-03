# Terminal environment

`modules/default.nix` imports `terminal` for Tower, Babel, and WSL. The desktop
composition adds `terminalDesktop` (Kitty) on Tower. No Home Manager is used.

| File | Change here |
| --- | --- |
| `default.nix` | Shared CLI packages and imports |
| `shell.nix` | Fish aliases, abbreviations, fuzzy navigation, editor helpers |
| `prompt.nix` | Starship context and appearance |
| `workflow.nix` | Atuin history, Git/delta, help, NixOS workflow commands |
| `emulator.nix`, `kitty.conf` | Desktop terminal wrapper, colors, font, keys |
| `zellij.kdl` | On-demand sessions, shell, input mode, theme |

Kitty and Zellij use small package wrappers to select these checked-in config
files. There is no home-file deployment. Override with their normal `--config`
option when experimenting. Fish, Starship, Atuin, and zoxide use native NixOS
modules. Starship respects an existing personal Starship config if present.
Atuin reads `/etc/atuin/config.toml`; its history database stays in each user's
local data directory. Sync and update checks are disabled; no account is needed.
Run `atuin import fish` explicitly if you want to import existing Fish history.

Bash remains the login shell. Kitty and Zellij launch Fish explicitly; elsewhere,
including WSL and SSH, run `fish` to enter the interactive environment. Scripts
continue to use their shebang interpreters. Do not paste Bash syntax into Fish
without adapting it, or run the command with `bash -c`.

## Daily use

Run `terminal-help` for the concise command list.

- `z NAME` / `zi`: frequent-directory jump / interactive picker.
- `cdf`: fuzzy directory picker; `croot`: current Git repository root.
- Ctrl-T / Alt-C: fzf file insertion / directory navigation.
- Ctrl-R: local Atuin history, initially filtered to the current directory.
- `fe`: select files with previews and open in `$EDITOR`.
- `rge PATTERN`: select files containing text and open in `$EDITOR`.
- `y`: Yazi; quit to change the shell's directory. Yazi and Lazygit offer `?` help.
- `lg`: Lazygit. `gs`, `gd`, `gl` expand into visible Git commands in Fish.
- `zellij`: start explicitly; Ctrl-G toggles locked mode to protect application
  shortcuts. Detached sessions keep processes running; reboot resurrection
  restores layouts rather than preserving live processes.
- Kitty: Ctrl-Shift-T creates a tab; Ctrl-Shift-Enter splits; Ctrl-Shift-H/J/K/L
  selects a neighboring pane. Kitty's keyboard mapping overrides its usual
  Ctrl-Shift-L layout cycling binding.

`fe` and `rge` support whitespace in filenames. `$EDITOR` may contain simple
space-separated arguments, but is not evaluated as shell code. `rge` selects
matching files, rather than jumping to individual matching lines.

## NixOS workflow

`cdc` opens `/etc/nixos`; `econf` opens `flake.nix` with `$EDITOR`.

- `nixos-workflow check`: Statix and flake checks; never activates.
- `nixos-workflow format`: formats the repository with Alejandra.
- `nixos-workflow build HOST`: builds an explicit host without activation.
- `nixos-workflow diff HOST`: builds, then compares with this machine's active
  generation using nvd; use the matching host for a meaningful comparison.
- `nixos-workflow generations`: lists local system generations.
- `nixos-workflow switch HOST`: explicitly builds and activates using nh; refuses
  a target that differs from the local hostname. It prints the Git diff summary.
- `nh search TEXT`, `manix OPTION`, `ni`: packages, option docs, Nix inspection.

Build/check commands preserve the existing lock file. Formatting changes files;
`switch` changes the running system. No generic `rebuild` activation alias remains.

Tokyo Night applies to Kitty and Zellij; the existing Stylix desktop theme stays
in `../theme.nix`. Fonts remain in `../desktop.nix`. Editor themes are independent.
