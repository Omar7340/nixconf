{
  services.flaresolverr.enable = true;
  services.flaresolverr.openFirewall = true;

  networking.nameservers = [ "1.1.1.1" ]; # cloudflare dns TODO : Add adguard service

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

    recyclarr = {
      enable = true;
      configuration = {
        sonarr = {
          series = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            delete_old_custom_formats = true;

            quality_definition = {
              type = "series";
            };

            custom_formats = [
              {
                trash_ids = [
                  "07a32f77690263bb9fda1842db7e273f" # VOSTFR
                ];
              }
            ];
          };
        };

        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            delete_old_custom_formats = true;

            quality_definition = {
              type = "movie";
            };

            custom_formats = [
              {
                trash_ids = [
                  "9172b2f683f6223e3a1846427b417a3d" # VOSTFR
                ];
              }
            ];
          };
        };
      };
    };

    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
    jellyseerr.enable = true;
  };
}
