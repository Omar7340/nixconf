{
  config,
  lib,
  pkgs,
  ...
}: {
  # Both boot configurations use the same user-published wallpaper and palette.
  services.displayManager.sddm = {
    package = lib.mkDefault pkgs.kdePackages.sddm;
    theme = "${./greeter}";
    wayland.compositor = "kwin";
    extraPackages = [pkgs.kdePackages.qtdeclarative];
    settings.General.GreeterEnvironment = lib.mkForce "QT_WAYLAND_SHELL_INTEGRATION=layer-shell,QML_XHR_ALLOW_FILE_READ=1,QT_QUICK_CONTROLS_STYLE=Basic";
  };
  # Only the desktop owner writes image/JSON data. Theme code stays immutable.
  systemd.tmpfiles.rules = [
    "d /var/lib/niri-greeter 2750 ${config.nixconf.user.name} sddm - -"
  ];
}
