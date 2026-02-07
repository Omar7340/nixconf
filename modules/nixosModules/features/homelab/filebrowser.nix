# TODO remove nixarr and use vanilla
# FIX managment of permission
{
  flake.nixosModules.homelab =
    { pkgs, config, ... }:
    let
      cfg = config.homelab;
    in
    {
      users.users.babeldrive = {
        isSystemUser = true;
        group = "babeldrive";
        extraGroups = [ "media" ];
      };
      users.groups.babeldrive = { };

      systemd.tmpfiles.rules = [
        "d /var/lib/babeldrive 0770 babeldrive babeldrive"
      ];

      users.users.${cfg.user}.extraGroups = [
        "babeldrive"
      ];

      systemd.services.babeldrive = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = "babeldrive";
          Restart = "on-failure";
          ExecStart = ''
            ${pkgs.filebrowser}/bin/filebrowser \
              --port ${toString cfg.babeldrive.port} \
              --database /var/lib/babeldrive/filebrowser.db \
              --root /mnt/media \
              --cacheDir /var/cache/babeldrive \
              --noauth \
              --disableExec
          '';
        };

      };
    };
}
