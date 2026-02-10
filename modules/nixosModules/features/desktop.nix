{ inputs, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
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
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
            user = "greeter";
          };

          initial_session = {
            command = "niri-session";
            user = "kage";
          };
        };
      };

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${system}.default
        alacritty
        firefox
        swaybg

      ];

    };
}
