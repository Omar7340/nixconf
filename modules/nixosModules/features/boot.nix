{
  flake.nixosModules.boot =
    { pkgs, ... }:
    {
      boot = {
        plymouth = {
          enable = true;
          theme = "rings";
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
