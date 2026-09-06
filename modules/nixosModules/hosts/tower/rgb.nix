{
  pkgs,
  config,
  ...
}: let
  pythonEnv = pkgs.python3.withPackages (ps: [ps.openrgb-python]);
  script = pkgs.writeText "fill_random.py" (builtins.readFile ./OpenRGB/fill_random.py);
in {
  environment.systemPackages = [pkgs.i2c-tools];
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  services.hardware = {
    deepcool-digital-linux.enable = true;
    openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };
  };
  systemd.services.openrgb-client = {
    description = "Start the OpenRGB animation client";
    after = ["openrgb.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/python ${script}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
  users.groups.i2c.members = [config.nixconf.user.name];
  networking.firewall.allowedUDPPorts = [5568 6454 21324 6742];
  systemd.tmpfiles.rules = ["L+ '/var/lib/OpenRGB/OpenRGB.json' - - - - ${./OpenRGB/OpenRGB.json}"];
}
