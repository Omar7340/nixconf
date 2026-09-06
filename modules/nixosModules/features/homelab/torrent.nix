{
  config,
  pkgs,
  ...
}: let
  cfg = config.homelab;
  rpcPort = config.services.transmission.settings.rpc-port;
in {
  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = config.sops.secrets.wireguardConfig.path;
    accessibleFrom = cfg.trustedNetworks;
    portMappings = [
      {
        from = rpcPort;
        to = rpcPort;
      }
    ];
    openVPNPorts = [
      {
        port = 60729;
        protocol = "both";
      }
    ];
  };
  systemd.services.transmission.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    webHome = pkgs.flood-for-transmission;
    group = "media";
    settings = {
      umask = "007";
      rpc-bind-address = "192.168.15.1";
      rpc-whitelist = "127.0.0.1,192.168.*,100.*";
      rpc-whitelist-enabled = true;
      rpc-authentication-required = false;
      rpc-host-whitelist-enabled = false;
      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = cfg.downloadDir;
    };
  };
  homelab.catalog = [
    {
      name = "Transmission";
      icon = "transmission.png";
      subdomain = "dl";
      address = "192.168.15.1";
      port = rpcPort;
      path = "/transmission/web/";
      widget = {
        type = "transmission";
        url = "http://192.168.15.1:${toString rpcPort}";
      };
    }
  ];
}
