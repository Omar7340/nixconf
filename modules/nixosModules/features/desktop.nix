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
      hardware.bluetooth.enable = true;
      services.upower.enable = true;
      services.tuned.enable = true;

      environments.systemPackages = with pkgs; [
        inputs.noctalia.packages.${system}.default
        alacritty
        firefox

      ];

    };
}
