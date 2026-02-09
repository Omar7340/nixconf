# FIX managment of permission
{
  flake.nixosModules.homelab =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.homelab;
    in
    {
      services.filebrowser = {
        enable = true;
        group = "media";
        settings = {
          root = "/mnt/media";
          port = cfg.babeldrive.port;
          auth.method = "noauth";
        };
      };

      homelab.catalog =
        let
          cfg = config.homelab;
          domain = cfg.domain;
          inherit (lib.strings) toLower;
        in
        [
          rec {
            icon = "filebrowser.png";
            name = "BabelDrive";
            href = "https://${sub}.${domain}";
            ping = href;
            sub = "bd";
            port = toString cfg.babeldrive.port;
            widget = {
              type = "filebrowser";
              url = "http://localhost:${port}";
            };
          }
        ];
    };
}
