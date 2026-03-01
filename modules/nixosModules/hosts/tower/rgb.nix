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
    environment.systemPackages = with pkgs; [
      i2c-tools
    ];
    boot.kernelModules = ["i2c-dev" "i2c-piix4"];
    users.groups.i2c.members = [config.preferences.user.name];

    networking.firewall = {
      allowedUDPPorts = [5568 6454 21324 6742]; # WLED default port
    };
    # TODO see startup profile
    # FIX issue when starting, doesnt discover WLED (you need to stop system service and run openrgb as sudo) need more digging
  };
}
