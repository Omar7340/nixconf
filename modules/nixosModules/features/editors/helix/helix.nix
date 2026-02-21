{
  flake.nixosModules.helix =
    { pkgs, config, ... }:
    {

      environment.systemPackages = with pkgs; [
        helix
        markdown-oxide
        # LSP
        nil
        nixd
        taplo
        yaml-language-server
        lua-language-server
      ];

      hjem.users.${config.preferences.user.name} = {
        files = {
          ".config/helix/languages.toml".source = ./languages.toml;
          ".config/helix/config.toml".source = ./config.toml;
          ".config/.moxide.toml".source = ./moxide.toml;
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
