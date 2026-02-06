{ lib, ... }:
{
  flake.nixosModules.homelab =
    let

      inherit (lib) mkOption types;
    in
    {

      options.homelab.domain = mkOption {
        type = types.str;
        default = "babel.local";
      };

      # list of services enabled on the homelab
      # easyer to configure reverse proxy
      options.homelab.catalog = mkOption {
        type = types.listOf types.attrs;
      };
    };
}
