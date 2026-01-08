{ config, pkgs, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;

    allowedHosts = "192.168.1.174:8082";

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = [
            "/"
            "/mnt/media"
          ];
          expanded = true;
          label = "Système";
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
        "Gestion des Médias" = [
          {
            "Prowlarr" = {
              icon = "prowlarr.png";
              href = "http://192.168.1.174:9696";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "6acd92d68d5a4fb284387864813ceb15";
              };
            };
          }
          {
            "Radarr" = {
              icon = "radarr.png";
              href = "http://192.168.1.174:7878";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "72d00c6b890349a78168d0c3244e8159";
              };
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.png";
              href = "http://192.168.1.174:8989";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "b98620222f7f4504af4591a8aa55c6af";
              };
            };
          }
        ];
      }
      {
        "Streaming & Requêtes" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              href = "http://192.168.1.174:8096";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "e71e68a019bc4a258016cad6d01c3adc";
                enableNowPlaying = true;
              };
            };
          }
          {
            "Jellyseerr" = {
              icon = "jellyseerr.png";
              href = "http://192.168.1.174:5055";
              widget = {
                type = "jellyseerr";
                url = "http://localhost:5055";
                key = "MTc2NzgzMjg5MDM3MDQ5N2U3ZWIwLWIzNTctNDg1Yy04YjVjLTBiZWMwN2I0NzY5Ng==";
              };
            };
          }
        ];
      }
      {
        "Téléchargement" = [
          {
            "Transmission" = {
              icon = "transmission.png";
              href = "http://192.168.1.174:9091";
              widget = {
                type = "transmission";
                url = "http://localhost:9091";
              };
            };
          }
        ];
      }
    ];
  };
}
