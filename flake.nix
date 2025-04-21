{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, nixos-hardware, ... }@inputs:
    let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # use "nixos", or your hostname as the name of the configuration
      # it's a better practice than "default" shown in the video
      nixosConfigurations = {
        # set a new config for each workstation
        # default = nixpkgs.lib.nixosSystem {
        #   specialArgs = {inherit inputs;};
        #   modules = [
        #     ./hosts/default/configuration.nix
        #   ];
        # };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/wsl/configuration.nix
          ];
        };
        surface5 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            ./hosts/surface5/configuration.nix
            ./nixosModules/terminal.nix
            ./nixosModules/desktopApps.nix
          ];
        };
      };
    };
}
