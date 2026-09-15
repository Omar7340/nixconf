{
  pkgs,
  lib,
  ...
}: let
  theme = "cuts";
in {
  boot = {
    # Keep both boot stages quiet so Plymouth remains uninterrupted. Critical
    # failures still surface through `boot.shell_on_fail` below.
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader = {
      limine = {
        enable = true;
        enableEditor = false;
        # Initrd images are about 120 MiB on this host; keep enough rollbacks
        # without exhausting the 1 GiB EFI system partition.
        maxGenerations = 3;
        resolution = "1920x1080";

        # Minimal Tokyo Night styling inspired by Omarchy's Limine menu.
        style = lib.mkForce {
          wallpapers = [];
          backdrop = "1a1b26";
          interface = {
            resolution = "1920x1080";
            branding = "NixOS · tower";
            brandingColor = "9ece6a";
            helpColor = "9ece6a";
            helpColorBright = "9ece6a";
          };
          graphicalTerminal = {
            palette = "15161e;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;a9b1d6";
            brightPalette = "414868;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;c0caf5";
            foreground = "c0caf5";
            brightForeground = "c0caf5";
            background = "1a1b26";
            brightBackground = "24283b";
          };
        };

        additionalFiles."EFI/memtest86/memtest86.efi" = pkgs.memtest86-efi + "/BOOTX64.efi";
        extraEntries = ''
          /Memory test (Memtest86+)
            protocol: chainload
            path: boot():/EFI/memtest86/memtest86.efi
        '';
      };
      timeout = 3;
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      theme = lib.mkForce theme;
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = [theme];})];
    };
    # Load the complete NVIDIA display stack before Plymouth starts. Loading only
    # `nvidia` leaves `nvidia_drm` until stage 2, causing a late framebuffer mode
    # switch and a visibly interrupted animation.
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];
    kernelParams = [
      "nvidia_drm.modeset=1"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
