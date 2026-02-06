{
  flake.nixosModules.homelab =
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

        services = map (
          item:
          builtins.removeAttrs item [
            "sub"
            "port"
          ]
        ) config.homelab.catalog;
      };
    };
}
