{
  flake.nixosModules.multimedia =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent
        vlc
        pear-desktop
      ];
    };
}
