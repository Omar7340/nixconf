{
  flake.nixosModules.helix =
    { pkgs, config, ... }:
    {

      environment.systemPackages = with pkgs; [ helix ];
      hjem.users.${config.preferences.user.name} = {
        files = {
          ".config/helix/languages.toml".source = ./languages.toml;

          ".config/helix/config.toml".source = ./config.toml;
        };
      };

      hjem.users.root = {
        files = {
          ".config/helix/languages.toml".source = ./languages.toml;

          ".config/helix/config.toml".source = ./config.toml;
        };
      };
    };
}
