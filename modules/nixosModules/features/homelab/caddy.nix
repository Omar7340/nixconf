{config, ...}: let
  cfg = config.homelab;
  mkVirtualHost = service: {
    name = "${service.subdomain}.${cfg.domain}";
    value.extraConfig = ''
      reverse_proxy ${service.address}:${toString service.port}
    '';
  };
in {
  services.caddy = {
    enable = true;
    virtualHosts = builtins.listToAttrs (map mkVirtualHost cfg.catalog);
  };
}
