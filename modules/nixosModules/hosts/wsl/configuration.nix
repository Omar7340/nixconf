{ inputs, self, ... }:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostWsl
      self.nixosModules.base
      self.nixosModules.nvf
    ];
  };

  flake.nixosModules.hostWsl =
    { ... }:
    {
      imports = [ inputs.nixos-wsl.nixosModules.default ];
      # Pas de bootloader ici, c'est géré par WSL
      wsl.enable = true;
      wsl.defaultUser = "nixos";

      networking.hostName = "nixos-wsl";
      nixpkgs.hostPlatform = "x86_64-linux";

      system.stateVersion = "25.05";
    };
}
