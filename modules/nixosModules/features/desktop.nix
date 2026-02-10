{ inputs, self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        self.nixosModules.browsers
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
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

        targets = {
          plymouth.enable = false;
        };

        fonts = {
          serif = {
            package = pkgs.nerd-fonts.iosevka-term-slab;
            name = "IosevkaTermSlab Nerd Font";
          };
          sansSerif = {
            package = pkgs.nerd-fonts.iosevka;
            name = "Iosevka Nerd Font";
          };
          monospace = {
            package = pkgs.nerd-fonts.iosevka-term;
            name = "IosevkaTerm Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 34;
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${system}.default
        alacritty
        swaybg
      ];
    };
}
