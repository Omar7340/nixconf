{ inputs, self, ... }:
{
  flake.nixosConfigurations.tower = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostTower
      self.nixosModules.base
      self.nixosModules.multimedia
      self.nixosModules.desktop
      self.nixosModules.gaming
      self.nixosModules.boot
      self.nixosModules.nvf
    ];
  };

  flake.nixosModules.hostTower =

    { config, pkgs, ... }:

    {

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "tower";
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Enable networking
      networking.networkmanager.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "fr";
        variant = "";
      };

      # Configure console keymap
      console.keyMap = "fr";

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.kage = {
        isNormalUser = true;
        description = "Kage";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.05"; # Did you read the comment?

    };
}
