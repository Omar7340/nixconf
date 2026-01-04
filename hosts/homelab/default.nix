{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader spécifique au hardware réel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "BabelNix";
  networking.networkmanager.enable = true;

  # Services spécifiques
  services.tailscale.enable = true;
  services.openssh.enable = true;
  
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Utilisateur spécifique
  users.users.babel = {
    isNormalUser = true;
    description = "babel";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "25.05";
}
