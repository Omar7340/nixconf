{
  pkgs,
  config,
  lib,
  ...
}: {
  options.nixconf.desktop.session = lib.mkOption {
    type = lib.types.enum ["plasma" "niri"];
    default = "plasma";
    description = "Desktop session selected by this system generation or specialization.";
  };
  config = {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      corefonts
      unifont
    ];
    services = {
      desktopManager.plasma6.enable = config.nixconf.desktop.session == "plasma";
      displayManager.defaultSession =
        if config.nixconf.desktop.session == "niri"
        then "niri"
        else "plasma";
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      xserver.enable = true;
    };
    programs.kdeconnect.enable = true;
    hardware.i2c.enable = true;
    users.users.${config.nixconf.user.name}.extraGroups = ["i2c"];
    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "monitor-brightness";
        runtimeInputs = [python3 ddcutil libnotify];
        text = ''exec python3 ${./monitor-brightness.py} "$@"'';
      })
      bibata-cursors
      kdePackages.kamoso
      kdePackages.plasma-browser-integration
    ];
  };
}
