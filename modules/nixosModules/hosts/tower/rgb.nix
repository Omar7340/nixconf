{
  flake.nixosModules.towerRGB = {
    pkgs,
    config,
    ...
  }: {
    services.hardware.deepcool-digital-linux.enable = true;

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    systemd.services.openrgb-client = {
      description = "Script Python qui demarre un client OpenRGB pour lancer une animation";

      after = ["openrgb.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = "${pkgs.python3}/bin/python /var/lib/OpenRGB/main.py";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    users.groups.i2c.members = [config.preferences.user.name];

    networking.firewall = {
      allowedUDPPorts = [5568 6454 21324 6742]; # WLED default port
    };

    systemd.tmpfiles.rules = [
      "L+ '/var/lib/OpenRGB/OpenRGB.json' - - - - ${./OpenRGB/OpenRGB.json}"
      "L+ '/var/lib/OpenRGB/main.py' - - - - ${./OpenRGB/fill_random.py}"
    ];
  };
}
