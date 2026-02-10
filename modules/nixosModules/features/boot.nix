{
  flake.nixosModules.boot =
    { pkgs, lib, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = lib.mkForce "rings"; # force due to stylix ttrying to override it
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
          ];

        };

        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
        loader.timeout = 0;
      };
    };
}
