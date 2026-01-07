{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader spécifique au hardware réel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "babel";
  networking.networkmanager.enable = true;

  # Services spécifiques
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
    };
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Utilisateur spécifique
  users.users.babel = {
    isNormalUser = true;
    description = "babel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJqgDOdY6OLzXCTHRuWAVHP8zEJ8PYtqJUfrLeTJKSA nixos@nixos"
  ];

  system.stateVersion = "25.05";
}
