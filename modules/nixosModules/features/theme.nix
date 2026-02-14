{
  flake.nixosModules.theme =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

        targets = {
          plymouth.enable = false;
          nvf.enable = false;
        };

        fonts = {
          serif = {
            package = pkgs.nerd-fonts.fira-code;
            name = "Fira Code Nerd Font";
          };
          sansSerif = {
            package = pkgs.nerd-fonts.fira-code;
            name = "Fira Code Nerd Font";
          };
          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "Fira Code Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };
      };
    };
}
