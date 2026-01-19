{
  services.flaresolverr.enable = true;
  services.flaresolverr.openFirewall = true;

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

        radarr = {
          movies-vostfr = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            include = [
              { template = "radarr-quality-definition-movie"; }
              { template = "radarr-quality-profile-hd-bluray-web-french-vostfr"; }
              { template = "radarr-custom-formats-hd-bluray-web-french-vostfr"; }
            ];
          };
        };

        sonarr = {
          series-vostfr = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            include = [
              { template = "sonarr-quality-definition-series"; }
              { template = "sonarr-v4-quality-profile-bluray-web-1080p-french-vostfr"; }
              { template = "sonarr-v4-custom-formats-bluray-web-1080p-french-vostfr"; }
              { template = "sonarr-quality-definition-anime"; }
              { template = "sonarr-v4-quality-profile-1080p-french-anime-vostfr"; }
              { template = "sonarr-v4-custom-formats-1080p-french-anime-vostfr"; }
            ];

            quality_profiles = [
              {
                name = "FR-VOSTFR-WEB-1080p";
                upgrade = {
                  allowed = true;
                  until_quality = "Bluray-1080p";
                };

                qualities = [
                  { name = "Bluray-1080p"; }
                  { name = "Bluray-1080p Remux"; }
                  { name = "WEBDL-1080p"; }
                  { name = "WEBRip-1080p"; }
                ];
              }
              {
                name = "FR-ANIME-VOSTFR";
                upgrade = {
                  allowed = true;
                  until_quality = "Bluray-1080p";
                };
                qualities = [
                  { name = "Bluray-1080p"; }
                  { name = "Bluray-1080p Remux"; }
                  { name = "WEBDL-1080p"; }
                  { name = "WEBRip-1080p"; }
                ];
              }
            ];
          };

        };
      };
    };

    bazarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
    jellyseerr.enable = true;
  };
}
