{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.babel = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostBabel
      self.nixosModules.base
      self.nixosModules.dev
      self.nixosModules.homelab
    ];
  };

  flake.nixosModules.hostBabel = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostBabel
    ];

    # Bootloader spécifique au hardware réel
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "babel";
    networking.networkmanager.enable = true;

    networking.nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      dnsovertls = "true";
    };

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

    preferences.user.name = "babel";

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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEp5ExRYPh7Jl+YVTrigl+emwUcQwAGGfeM/C5SqRKoo kage@tower"
    ];

    system.stateVersion = "25.05";
  };
}
