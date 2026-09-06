{
  inputs,
  lib,
  ...
}: let
  mkModule = imports: {inherit imports;};

  nixosModules = rec {
    base = mkModule [
      inputs.nix-index-database.nixosModules.nix-index
      ./nixosModules/base/git.nix
      ./nixosModules/base/locals.nix
      ./nixosModules/base/nix.nix
      ./nixosModules/base/shortcuts.nix
      ./nixosModules/base/user.nix
    ];

    server = mkModule [./nixosModules/profiles/server.nix];
    development = mkModule [nixvim helix ./nixosModules/features/development.nix];
    desktop = mkModule [
      inputs.stylix.nixosModules.stylix
      browsers
      theme
      home
      office
      ./nixosModules/features/desktop.nix
    ];
    homelab = mkModule [
      inputs.vpn-confinement.nixosModules.default
      secrets
      ./nixosModules/features/homelab/options.nix
      ./nixosModules/features/homelab/adguard.nix
      ./nixosModules/features/homelab/caddy.nix
      ./nixosModules/features/homelab/filebrowser.nix
      ./nixosModules/features/homelab/homepage.nix
      ./nixosModules/features/homelab/jellyfin.nix
      ./nixosModules/features/homelab/torrent.nix
    ];

    boot = mkModule [./nixosModules/features/boot.nix];
    browsers = mkModule [./nixosModules/features/browsers/browsers.nix];
    office = mkModule [./nixosModules/features/office.nix];
    gaming = mkModule [./nixosModules/features/gaming.nix];
    ai = mkModule [./nixosModules/features/ai.nix];
    multimedia = mkModule [./nixosModules/features/multimedia.nix];
    theme = mkModule [./nixosModules/features/theme.nix];
    home = mkModule [./nixosModules/features/home/home.nix];
    secrets = mkModule [inputs.sops-nix.nixosModules.sops ./nixosModules/features/secrets/sops.nix];

    helix = mkModule [./nixosModules/features/editors/helix/helix.nix];
    nixvim = mkModule [
      inputs.nixvim.nixosModules.nixvim
      ./nixosModules/features/editors/nixvim/nixvim.nix
      ./nixosModules/features/editors/nixvim/autocmd.nix
      ./nixosModules/features/editors/nixvim/completions.nix
      ./nixosModules/features/editors/nixvim/options.nix
      ./nixosModules/features/editors/nixvim/performance.nix
      ./nixosModules/features/editors/nixvim/plugins/general.nix
      ./nixosModules/features/editors/nixvim/plugins/lsp.nix
      ./nixosModules/features/editors/nixvim/plugins/lualine.nix
      ./nixosModules/features/editors/nixvim/plugins/neorg.nix
      ./nixosModules/features/editors/nixvim/plugins/telescope.nix
    ];
    nvf = mkModule [inputs.nvf.nixosModules.default ./nixosModules/features/editors/nvf.nix];

    towerRgb = mkModule [./nixosModules/hosts/tower/rgb.nix];
    towerHost = mkModule [
      ./nixosModules/hosts/tower/configuration.nix
      ./nixosModules/hosts/tower/hardware-configuration.nix
    ];
    wslHost = mkModule [inputs.nixos-wsl.nixosModules.default ./nixosModules/hosts/wsl/configuration.nix];
    babelHost = mkModule [
      inputs.disko.nixosModules.disko
      ./nixosModules/hosts/babel/disko.nix
      ./nixosModules/hosts/babel/configuration.nix
      ./nixosModules/hosts/babel/hardware-configuration.nix
    ];
  };

  mkHost = modules: inputs.nixpkgs.lib.nixosSystem {inherit modules;};
in {
  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
    description = "Internal reusable flake helpers and module definitions.";
  };

  imports = [
    ./flake-parts.nix
    ./wrappedPrograms/neovim/neovim.nix
  ];

  config.flake = {
    inherit nixosModules;
    lib.diskoConfigurations.babel = import ./nixosModules/hosts/babel/disko.nix;

    nixosConfigurations = {
      tower = mkHost [
        inputs.hjem.nixosModules.default
        nixosModules.towerHost
        nixosModules.base
        nixosModules.development
        nixosModules.multimedia
        nixosModules.desktop
        nixosModules.gaming
        nixosModules.boot
        nixosModules.towerRgb
        nixosModules.ai
      ];
      wsl = mkHost [nixosModules.wslHost nixosModules.base nixosModules.nvf];
      babel = mkHost [
        inputs.hjem.nixosModules.default
        nixosModules.babelHost
        nixosModules.base
        nixosModules.development
        nixosModules.server
        nixosModules.homelab
      ];
    };
  };
}
