{
  flake.nixosModules.homelab =
    { config, ... }:

    let
      cfg = config.homelab;
      baseDomain = cfg.domain;

      mkVHost =
        {
          sub,
          ip ? "127.0.0.1",
          port,
        }:
        {
          name = "${sub}.${baseDomain}";
          value = {
            extraConfig = ''
              reverse_proxy ${toString ip}:${toString port}
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
              ip = null;
            }) cfg.catalog
          )
        );
      };
    };
}
