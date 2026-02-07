{ inputs, ... }:
{
  flake.nixosModules.base =
    { pkgs, ... }:
    {

      imports = [
        inputs.nix-index-database.nixosModules.nix-index
      ];
      programs.nix-index-database.comma.enable = true;

      programs.direnv = {
        enable = true;
        silent = false;
        loadInNixShell = true;
        direnvrcExtra = "";
        nix-direnv.enable = true;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixpkgs.config.allowUnfree = true;

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3";
          dates = "weekly";
        };

        flake = "/etc/nixos";
      };

      environment.systemPackages = with pkgs; [
        statix
        manix
        nix-inspect
      ];
    };
}
