{
  flake.nixosModules.homelab =
    { config, ... }:
    let
      jf_user = "jellyfin";
      jf_group = "media";
      media_dir = "/mnt/media";
      state_dir = "${media_dir}/.state";
    in
    {
      services.jellyfin = {
        enable = true;
        user = jf_user;
        group = jf_group;
        logDir = "${state_dir}/log";
        cacheDir = "${state_dir}/cache";
        dataDir = "${state_dir}/data";
        configDir = "${state_dir}/config";
      };

      users = {
        groups.${jf_group} = { };
        users.${jf_user} = {
          isSystemUser = true;
          group = jf_group;
        };
      };

      systemd.tmpfiles.rules = [
        "d '${state_dir}'        0700 ${jf_user} root - -"
        "d '${state_dir}/log'    0700 ${jf_user} root - -"
        "d '${state_dir}/cache'  0700 ${jf_user} root - -"
        "d '${state_dir}/data'   0700 ${jf_user} root - -"
        "d '${state_dir}/config' 0700 ${jf_user} root - -"

        "d '${media_dir}/library' 0775 ${jf_user} ${jf_group} - -"
      ];

      homelab.catalog =
        let
          cfg = config.homelab;
          domain = cfg.domain;
          jf_port = "8096";
        in
        [
          rec {
            icon = "jellyfin.png";
            name = "Jellyfin";
            href = "https://${sub}.${domain}";
            ping = href;
            sub = "jf";
            port = jf_port;
          }
        ];
    };
}
