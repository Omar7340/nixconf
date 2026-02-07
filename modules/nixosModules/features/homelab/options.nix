{
  flake.nixosModules.homelab =
    { config, lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {

      options = {
        homelab = {
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

      config.homelab.catalog =
        let
          domain = config.homelab.domain;
          inherit (lib.strings) toLower;
        in
        [
          rec {
            icon = "${toLower name}.png";
            name = "Transmission";
            href = "https://${sub}.${domain}";
            sub = "dl";
            port = toString config.nixarr.transmission.uiPort;
            widget = {
              type = toLower name;
              url = "http://localhost:${port}";
            };
          }
          rec {
            icon = "jellyfin.png";
            name = "Jellyfin";
            href = "https://${sub}.${domain}";
            sub = "jf";
            port = "8096";
            widget = {
              type = toLower name;
              url = "http://localhost:${port}";
              enableNowPlaying = true;
              key = "e71e68a019bc4a258016cad6d01c3adc";
            };
          }
          rec {
            icon = "adguard.png";
            name = "AdGuard";
            href = "https://${sub}.${domain}";
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
}
