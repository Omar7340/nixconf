{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:NotAShelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # reusable modules
    nixosModules = {
      core = {
        imports = [
          ./modules/core/git.nix
          ./modules/core/nvf.nix
        ];
      };
    };
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.BabelNix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit self inputs;};
      modules = [
        ./hosts/homelab/configuration.nix
	inputs.nvf.nixosModules.default
	self.nixosModules.core
        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
