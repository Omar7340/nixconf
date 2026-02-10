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
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
            user = "greeter";
          };

          initial_session = {
            command = "niri-session";
            user = "kage";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        inputs.noctalia.packages.${stdenv.hostPlatform.system}.default
        alacritty
      ];
    };
}
