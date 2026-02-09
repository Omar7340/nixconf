{ inputs, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
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
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri";
            user = "greeter";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${system}.default
        alacritty
        firefox
        swaybg

      ];

    };
}
