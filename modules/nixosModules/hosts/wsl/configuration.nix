{ inputs, self, ... }:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostWsl
      self.nixosModules.git
      self.nixosModules.nix
      self.nixosModules.shortcuts
    ];
  };

  flake.nixosModules.hostWsl =
    { ... }:
    {
      # Pas de bootloader ici, c'est géré par WSL
      wsl.enable = true;
      wsl.defaultUser = "nixos";

      networking.hostName = "nixos-wsl";

      system.stateVersion = "25.05";
    };
}
