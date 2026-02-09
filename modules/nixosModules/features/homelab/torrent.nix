{ inputs, self, ... }:
{
  flake.nixosModules.homelab =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.vpn-confinments.nixosModules.default
        self.nixosModules.secrets-managment
      ];

      # Define VPN network namespace
      vpnNamespaces.wg = {
        enable = true;
        wireguardConfigFile = config.sops.secrets.wg_conf.path;
        accessibleFrom = [
          "192.168.0.0/24"
        ];
        portMappings = [
          {
            from = 9091;
            to = 9091;
          }
        ];
        openVPNPorts = [
          {
            port = 60729;
            protocol = "both";
          }
        ];
      };

      # Add systemd service to VPN network namespace
      systemd.services.transmission.vpnConfinement = {
        enable = true;
        vpnNamespace = "wg";
      };

      services.transmission =
        let
          cfg = config.homelab;
        in
        {
          enable = true;
          package = pkgs.transmission_4;
          webHome = pkgs.flood-for-transmission;
          group = "media";
          settings = {
            umask = "022";

            rpc-bind-address = "192.168.15.1"; # Bind RPC/WebUI to VPN network namespace address
            rpc-whitelist = "127.0.0.1,192.168.*,10.*"; # Access through loopback within VPN network namespace
            rpc-whitelist-enabled = true;
            rpc-authentication-required = false;
            rpc-host-whitelist-enabled = false;
            blocklist-enabled = true;
            blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
            download-dir = cfg.download-dir;
          };
        };

      homelab.catalog =
        let
          domain = config.homelab.domain;
          inherit (lib.strings) toLower;
        in
        [
          rec {
            icon = "${toLower name}.png";
            name = "Transmission";
            href = "https://${sub}.${domain}/transmission/web/";
            ping = href;
            sub = "dl";
            ip = "192.168.15.1";
            port = toString config.services.transmission.settings.rpc-port;
            widget = {
              type = toLower name;
              url = "http://${ip}:${port}";
            };
          }
        ];
    };
}
