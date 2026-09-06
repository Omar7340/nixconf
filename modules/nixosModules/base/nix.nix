{pkgs, ...}: {
  programs = {
    nix-index-database.comma.enable = true;
    direnv = {
      enable = true;
      silent = false;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
        dates = "weekly";
      };
      flake = "/etc/nixos";
    };
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    statix
    nil
    nixd
    manix
    alejandra
    nix-inspect
  ];
}
