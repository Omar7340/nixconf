{
  config,
  lib,
  ...
}: let
  cfg = config.homelab;
  toDashboardEntry = service: {
    ${service.name} = lib.filterAttrs (_: value: value != null) {
      inherit (service) icon;
      href = "https://${service.subdomain}.${cfg.domain}${service.path}";
      ping = "https://${service.subdomain}.${cfg.domain}${service.path}";
      inherit (service) widget;
    };
  };
in {
  services = {
    glances.enable = true;
    homepage-dashboard = {
      enable = true;
      allowedHosts = "hp.${cfg.domain}";
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
            disk = ["/" cfg.downloadDir];
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
      services = [{Homelab = map toDashboardEntry (builtins.filter (service: service.name != "Homepage") cfg.catalog);}];
    };
  };
}
