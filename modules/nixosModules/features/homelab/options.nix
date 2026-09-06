{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  serviceType = types.submodule {
    options = {
      name = mkOption {type = types.str;};
      icon = mkOption {type = types.str;};
      subdomain = mkOption {type = types.str;};
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
      };
      port = mkOption {type = types.port;};
      path = mkOption {
        type = types.str;
        default = "";
      };
      widget = mkOption {
        type = types.nullOr types.attrs;
        default = null;
      };
    };
  };
  cfg = config.homelab;
in {
  options.homelab = {
    user = mkOption {
      type = types.str;
      default = "babel";
    };
    address = mkOption {
      type = types.str;
      default = "192.168.1.174";
    };
    trustedNetworks = mkOption {
      type = types.listOf types.str;
      default = ["192.168.1.0/24" "100.64.0.0/10"];
    };
    downloadDir = mkOption {
      type = types.str;
      default = "/mnt/media";
    };
    fileBrowser.port = mkOption {
      type = types.port;
      default = 7722;
    };
    domain = mkOption {
      type = types.str;
      default = "babel.local";
    };
    catalog = mkOption {
      type = types.listOf serviceType;
      default = [];
    };
  };

  config.homelab = {
    user = config.nixconf.user.name;
    catalog = [
      {
        name = "Homepage";
        icon = "homepage.png";
        subdomain = "hp";
        port = config.services.homepage-dashboard.listenPort;
      }
      {
        name = "AdGuard";
        icon = "adguard-home.png";
        subdomain = "ad";
        port = config.services.adguardhome.port;
        widget = {
          type = "adguard";
          url = "http://localhost:${toString config.services.adguardhome.port}";
          user = "";
          password = "";
        };
      }
    ];
  };

  config.networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [config.services.tailscale.port];
      extraInputRules = ''
        ip saddr { ${lib.concatStringsSep ", " cfg.trustedNetworks} } tcp dport { 22, 53, 80, 443 } accept
        ip saddr { ${lib.concatStringsSep ", " cfg.trustedNetworks} } udp dport 53 accept
      '';
    };
  };
}
