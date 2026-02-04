{
  description = "Configuration NixOS multi-systèmes";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Gestionnaire WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Neovim Framework
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
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
          babel = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs self; };
            modules = [
              inputs.disko.nixosModules.disko
              ./hosts/homelab/disk-config.nix
              ./hosts/homelab
              self.nixosModules.core
              inputs.nvf.nixosModules.default
              inputs.nixarr.nixosModules.default
              ./modules/services/arr
              ./modules/services/utils
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
