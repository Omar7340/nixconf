{ config, pkgs, ... }:

{
  services.glances.enable = true;

  services.homepage-dashboard = {
    enable = true;

    # --- WIDGETS (En-tête) ---
    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
          label = "Système";
        };
      }
      {
        weather = {
          label = "Météo";
          latitude = "48.8566";
          longitude = "2.3522";
          units = "metric";
          cache = 30;
        };
      }
      {
        datetime = {
          format = "LLLL";
        };
      }
    ];

    services = [
      {
        "Monitoring & Santé" = [
          {
            "Uptime Kuma" = {
              icon = "uptime-kuma.svg";
              href = "http://192.167.1.174:3001";
              widget = {
                type = "uptimekuma";
                url = "http://192.167.1.174:3001";
                slug = "default";
              };
            };
          }
          {
            "Glances" = {
              icon = "glances.svg";
              href = "http://192.167.1.174:61208";
              widget = {
                type = "glances";
                url = "http://192.167.1.174:61208";
              };
            };
          }
        ];
      }
      {
        "Media Server" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.svg";
              href = "http://192.167.1.174:8096";
              widget = {
                type = "jellyfin";
                url = "http://192.167.1.174:8096";
                key = "";
              };
            };
          }
          {
            "Jellyseerr" = {
              icon = "jellyseerr.svg";
              href = "http://192.167.1.174:5055";
              widget = {
                type = "jellyseerr";
                url = "http://192.167.1.174:5055";
                key = "MTc2NzgzMjg5MDM3MDQ5N2U3ZWIwLWIzNTctNDg1Yy04YjVjLTBiZWMwN2I0NzY5Ng";
              };
            };
          }
        ];
      }
      {
        "Gestionnaires (Arrs)" = [
          {
            "Radarr" = {
              icon = "radarr.svg";
              href = "http://192.167.1.174:7878";
              widget = {
                type = "radarr";
                url = "http://192.167.1.174:7878";
                key = "72d00c6b890349a78168d0c3244e8159";
              };
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.svg";
              href = "http://192.167.1.174:8989";
              widget = {
                type = "sonarr";
                url = "http://192.167.1.174:8989";
                key = "b98620222f7f4504af4591a8aa55c6af";
              };
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.svg";
              href = "http://192.167.1.174:9696";
              widget = {
                type = "prowlarr";
                url = "http://192.167.1.174:9696";
                key = "6acd92d68d5a4fb284387864813ceb15";
              };
            };
          }
        ];
      }
      {
        "Téléchargement" = [
          {
            "Transmission" = {
              icon = "transmission.svg";
              href = "http://192.167.1.174:9091";
              widget = {
                type = "transmission";
                url = "http://192.167.1.174:9091";
              };
            };
          }
        ];
      }
    ];
  };
}
