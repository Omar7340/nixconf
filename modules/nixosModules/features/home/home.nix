{
  flake.nixosModules.home =
    { pkgs, config, ... }:
    {
      hjem.users.${config.preferences.user.name} = {
        directory = "/home/${config.preferences.user.name}";
        clobberFiles = true;

        files = {
          ".config/niri/config.kdl".source = ./niri/config.kdl;
        };
      };
    };
}
