{
  config,
  lib,
  ...
}: let
  cfg = config.homelab;
in {
  services.filebrowser = {
    enable = true;
    group = "media";
    settings = {
      root = "${cfg.downloadDir}/library";
      port = cfg.fileBrowser.port;
      auth.method = "noauth";
    };
  };
  systemd.tmpfiles.settings.filebrowser."${cfg.downloadDir}/library".d.mode = lib.mkForce "0770";
  homelab.catalog = [
    {
      name = "BabelDrive";
      icon = "filebrowser.png";
      subdomain = "bd";
      port = cfg.fileBrowser.port;
      widget = {
        type = "filebrowser";
        url = "http://localhost:${toString cfg.fileBrowser.port}";
      };
    }
  ];
}
