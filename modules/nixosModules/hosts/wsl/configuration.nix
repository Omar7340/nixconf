{ inputs, self, ... }:
{
  flake.nixosConfiguration.wsl = inputs.nixpkgs.lib.nixosSystem {
    # Pas de bootloader ici, c'est géré par WSL
    wsl.enable = true;
    wsl.defaultUser = "nixos";

    networking.hostName = "nixos-wsl";

    system.stateVersion = "25.05";
  };
}
