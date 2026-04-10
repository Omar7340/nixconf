{
  flake.nixosModules.multimedia = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      qbittorrent
      vlc
      pear-desktop
      freecad-wayland
      orca-slicer
      (mpv.override {
        scripts = [
          pkgs.mpvScripts.uosc
        ];
      })
    ];
  };
}
