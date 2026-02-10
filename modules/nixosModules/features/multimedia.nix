{
  flake.nixosModules.multimedia =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vlc
        pear-desktop
      ];
    };
}
