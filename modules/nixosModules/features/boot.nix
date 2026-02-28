{
  flake.nixosModules.boot = {
    pkgs,
    lib,
    ...
  }: {
    boot = let
      choosedTheme = "cuts";
    in {
      # Bootloader.
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      plymouth = {
        enable = true;
        theme = lib.mkForce choosedTheme; # force due to stylix ttrying to override it
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {selected_themes = [choosedTheme];})
        ];
      };

      loader.systemd-boot.memtest86.enable = true;

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
  };
}
