{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
      hardware.graphics.enable = lib.mkDefault true;

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        modesetting.enable = true;
      };

      programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
          extraPackages = with pkgs; [
            SDL2
            gamescope
          ];
          protontricks.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [
        mangohud
        lutris
        heroic
        bottles
        prismlauncher
        steam-run
        discord
        dolphin-emu
        dualsensectl
      ];
    };
}
