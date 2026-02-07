{
  flake.nixosModules.homelab =
    { config, pkgs, ... }:

    {
      services.glances.enable = true;

      services.homepage-dashboard = {
        enable = true;

        allowedHosts = "hp.babel.local";

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

        services =
          let
            catalog = builtins.filter (item: item.name != "Homepage") config.homelab.catalog;
            mkServices =
              services:
              map (item: {
                "${item.name}" = (
                  builtins.removeAttrs item [
                    "sub"
                    "port"
                    "name"
                  ]
                );
              }) services;
          in
          [
            {
              "Homelab" = mkServices catalog;
            }
          ];
      };
    };
}
