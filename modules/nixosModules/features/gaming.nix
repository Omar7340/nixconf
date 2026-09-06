{
  pkgs,
  lib,
  ...
}: {
  hardware = {
    graphics.enable = lib.mkDefault true;
    nvidia = {
      open = true;
      modesetting.enable = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      extraPackages = with pkgs; [SDL2 gamescope];
      protontricks.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    mangohud
    heroic
    prismlauncher
    steam-run
    discord
    dolphin-emu
    dualsensectl
  ];
}
