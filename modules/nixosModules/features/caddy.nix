{
  flake.nixosModules.caddy =
    { config, lib, ... }:

    let
      baseDomain = "babel.local";

      servicesList = [
        {
          sub = "adguard";
          port = 3000;
        }
        {
          sub = "hp";
          port = 8082;
        }
        {
          sub = "jellyfin";
          port = 8096;
        }
        {
          sub = "transmission";
          port = 9091;
        }
      ];

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

        virtualHosts = builtins.listToAttrs (map mkVHost servicesList);
      };
    };
}
