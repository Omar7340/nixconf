{
  description = "Configuration NixOS multi-systèmes";

  inputs = {

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # pinned on this nixpkgs until this is resolved
    # issue https://github.com/NotAShelf/nvf/issues/1312
    nixpkgs.url = "github:nixos/nixpkgs/cad22e7d996aea55ecab064e84834289143e44a0";

    # Gestionnaire WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Framework
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake = {
        # On définit ici nos modules réutilisables (exportés par le flake)
        nixosModules = {
          core = ./modules/core; # Pointera vers modules/core/default.nix
        };

        nixosConfigurations = {
          # --- Machine 1 : WSL ---
          wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
              ./hosts/wsl
              self.nixosModules.core
              inputs.nixos-wsl.nixosModules.default
              inputs.nvf.nixosModules.default
            ];
          };

          # --- Machine 2 : Homelab ---
          BabelNix = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
              ./hosts/homelab
              self.nixosModules.core
              inputs.nvf.nixosModules.default
            ];
          };
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.nil
              pkgs.git
            ];
          };
        };
    };
}
