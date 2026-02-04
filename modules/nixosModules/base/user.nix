{
  flake.nixosModules.base =
    { lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.preferences = {
        user.name = mkOption {
          type = types.str;
          default = "kage";
        };
        user.mail = mkOption {
          type = types.str;
          default = "kage@localhost.local";
        };
      };
    };
}
