{
  flake.nixosModules.homelab =
    { config, lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {

      options = {
        homelab = {
          user = mkOption {
            type = types.str;
            default = "babel";
          };

          download-dir = mkOption {
            type = types.str;
            default = "/mnt/media";
          };

          babeldrive = {
            port = mkOption {
              type = types.int;
              default = 7722;
            };
          };

          domain = mkOption {
            type = types.str;
            default = "babel.local";
          };

          # list of services enabled on the homelab
          # easyer to configure reverse proxy
          catalog = mkOption {
            type = types.listOf types.attrs;
          };
        };
      };

      config.homelab = {
        user = config.preferences.user.name;
        catalog =
          let
            cfg = config.homelab;
            domain = config.homelab.domain;
            inherit (lib.strings) toLower;
          in
          [
            rec {
              icon = "${toLower name}.png";
              name = "Homepage";
              href = "https://${sub}.${domain}";
              ping = href;
              sub = "hp";
              port = toString config.services.homepage-dashboard.listenPort;
            }

            rec {
              icon = "adguard-home.png";
              name = "AdGuard";
              href = "https://${sub}.${domain}";
              ping = href;
              sub = "ad";
              port = toString config.services.adguardhome.port;
              widget = {
                type = toLower name;
                url = "http://localhost:${port}";
                # use sops-nix
                user = "";
                password = "";
              };
            }
          ];
      };
    };
}
