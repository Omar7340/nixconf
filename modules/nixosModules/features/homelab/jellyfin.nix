{config, ...}: let
  mediaDir = config.homelab.downloadDir;
  stateDir = "${mediaDir}/.state";
in {
  services.jellyfin = {
    enable = true;
    user = "jellyfin";
    group = "media";
    logDir = "${stateDir}/log";
    cacheDir = "${stateDir}/cache";
    dataDir = "${stateDir}/data";
    configDir = "${stateDir}/config";
  };
  users = {
    groups.media = {};
    users.jellyfin = {
      isSystemUser = true;
      group = "media";
    };
  };
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 0700 jellyfin root - -"
    "d '${stateDir}/log' 0700 jellyfin root - -"
    "d '${stateDir}/cache' 0700 jellyfin root - -"
    "d '${stateDir}/data' 0700 jellyfin root - -"
    "d '${stateDir}/config' 0700 jellyfin root - -"
    "d '${mediaDir}/library' 0775 jellyfin media - -"
  ];
  homelab.catalog = [
    {
      name = "Jellyfin";
      icon = "jellyfin.png";
      subdomain = "jf";
      port = 8096;
    }
  ];
}
