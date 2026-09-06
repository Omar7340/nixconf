{
  pkgs,
  lib,
  ...
}: let
  theme = "cuts";
in {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      theme = lib.mkForce theme;
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = [theme];})];
    };
    initrd.kernelModules = ["nvidia"];
    kernelParams = [
      "nvidia_drm.modeset=1"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
