{config, ...}: let
  cfg = config.homelab;
in {
  services.filebrowser = {
    enable = true;
    group = "media";
    settings = {
      root = cfg.downloadDir;
      port = cfg.fileBrowser.port;
      auth.method = "noauth";
    };
  };
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
