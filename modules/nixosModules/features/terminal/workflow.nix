{pkgs, ...}: let
  zellij = pkgs.symlinkJoin {
    name = "zellij-configured";
    paths = [pkgs.zellij];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/zellij --add-flags "--config ${./zellij.kdl}"
    '';
  };
  nixosWorkflow = pkgs.writeShellApplication {
    name = "nixos-workflow";
    runtimeInputs = [pkgs.git pkgs.nix pkgs.alejandra pkgs.statix pkgs.nh pkgs.nvd pkgs.nixos-rebuild pkgs.hostname];
    text = ''
      cd /etc/nixos
      action="''${1:-help}"
      host="''${2:-}"
      case "$action" in
        check) statix check .; nix flake check --no-update-lock-file path:/etc/nixos ;;
        format) alejandra . ;;
        generations) nixos-rebuild list-generations ;;
        diff|build|switch)
          case "$host" in tower|babel|wsl) ;; *) echo 'Specify target host: tower, babel, or wsl' >&2; exit 2 ;; esac
          if [[ "$action" == switch && "$(hostname)" != "$host" ]]; then
            echo "Refusing local activation: this machine is $(hostname), target is $host" >&2
            exit 2
          fi
          git diff --stat
          if [[ "$action" == switch ]]; then
            echo "Building and activating NixOS on $host"
            nh os switch --no-nom --no-update-lock-file -R "path:/etc/nixos#$host"
          else
            result=$(nix build --no-link --print-out-paths --no-update-lock-file "path:/etc/nixos#nixosConfigurations.$host.config.system.build.toplevel")
            echo "$result"
            if [[ "$action" == diff ]]; then nvd diff /run/current-system "$result"; fi
          fi
          ;;
        *) echo 'Usage: nixos-workflow check|format|generations|build HOST|diff HOST|switch HOST'
           echo 'diff compares the requested build with the local active system.' ;;
      esac
    '';
  };
  help = pkgs.writeShellScriptBin "terminal-help" ''
        cat <<'HELP'
    NAVIGATION (Fish)
      z / zi          frequent directory / interactive jump
      cdf / croot     fuzzy directory / Git repository root
      y               Yazi; exit into selected directory
    SEARCH (Fish)
      Ctrl-R          local Atuin history
      Ctrl-T / Alt-C  fzf files / directories
      fe / rge TEXT   select files / matching files and open in $EDITOR
    GIT & SYSTEM
      lg              Lazygit (press ? for help)
      gs / gd / gl    Fish abbreviations, expanded before execution
      btop            system monitor
      zellij          explicit persistent session; no auto-start
    NIXOS
      cdc / econf     repository / editor
      nixos-workflow  checks, formatting, builds, diffs, generations, activation
      nh search TEXT  package search
      manix OPTION    option documentation
      ni              interactive Nix inspection
    KITTY
      Ctrl-Shift-T    new tab
      Ctrl-Shift-Enter split; Ctrl-Shift-H/J/K/L move between panes
    CONFIGURATION
      /etc/nixos/modules/nixosModules/features/terminal/README.md
    HELP
  '';
in {
  programs.atuin = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    flags = ["--disable-up-arrow" "--disable-ai"];
    daemon.enable = false;
    settings = {
      auto_sync = false;
      update_check = false;
      search_mode = "fuzzy";
      filter_mode = "directory";
      style = "compact";
      inline_height = 15;
    };
  };
  programs.git.config = {
    core.pager = "${pkgs.delta}/bin/delta";
    interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
    delta = {
      navigate = true;
      side-by-side = false;
    };
    merge.conflictStyle = "zdiff3";
  };
  environment.systemPackages = [pkgs.delta zellij nixosWorkflow help];
}
