{
  flake.nixosModules.homelab =
    { config, ... }:

    let
      cfg = config.homelab;
      baseDomain = cfg.domain;

      mkVHost =
        { sub, port }:
        {
          name = "${sub}.${baseDomain}";
          value = {
            extraConfig = ''
              reverse_proxy localhost:${toString port}
            '';
          };
        };

    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.caddy = {
        enable = true;

        virtualHosts = builtins.listToAttrs (
          map mkVHost (
            map (builtins.intersectAttrs {
              sub = null;
              port = null;
            }) cfg.catalog
          )
        );
      };
    };
}
