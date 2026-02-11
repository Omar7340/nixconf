{ inputs, self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        self.nixosModules.browsers
        self.nixosModules.theme
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        corefonts
        unifont
      ];

      # needed for noctalia
      programs.niri.enable = true;
      services.upower.enable = true;
      services.tuned.enable = true;

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%A %d %B %Y à %Hh%M' --cmd niri-session";
            user = "greeter";
          };
        };
      };

      hardware.i2c.enable = true;

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        inputs.noctalia.packages.${stdenv.hostPlatform.system}.default
        ddcutil
        brightnessctl
        playerctl
        bitwarden-desktop
        alacritty
        fuzzel
      ];
    };
}
