{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.nixosModules.homelab =
    { ... }:
    {

      imports = [ inputs.nixarr.nixosModules.default ];

      nixarr = {
        enable = true;
        mediaDir = "/mnt/media/nixarr";
        stateDir = "/mnt/media/nixarr/.state/nixarr";

        vpn = {
          enable = true;
          wgConf = "/data/.secret/vpn/wg.conf";
        };

        jellyfin = {
          enable = true;
        };

        transmission = {
          enable = true;
          vpn.enable = true;
          peerPort = 54734; # Set this to the port forwarded by your VPN
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
            port = config.nixarr.transmission.uiPort;
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
            port = 8096;
            widget = {
              type = toLower name;
              url = "http://localhost:${port}";
              enableNowPlaying = true;
              key = "e71e68a019bc4a258016cad6d01c3adc";
            };
          }
        ];
    };
}
