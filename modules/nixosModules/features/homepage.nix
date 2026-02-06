{
  flake.nixosModules.homepage =
    { config, pkgs, ... }:

    {
      services.glances.enable = true;
      services.glances.openFirewall = true;

      services.homepage-dashboard = {
        enable = true;
        openFirewall = true;

        allowedHosts = "192.168.1.174:8082,100.123.123.28:8082,hp.babel.local";

        widgets = [
          {
            glances = {
              url = "http://localhost:61208";
              metric = "info";
              version = 4;
              cpu = true;
              cputemp = true;
              uptime = true;
              mem = true;
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
              locale = "fr";
              format = {
                dateStyle = "long";
                timeStyle = "short";
              };
            };
          }
        ];

        services = [
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
    };
}
