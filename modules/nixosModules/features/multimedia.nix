{
  flake.nixosModules.multimedia = {
    config,
    pkgs,
    ...
  }: let
    # FIX for issue https://github.com/NixOS/nixpkgs/issues/468456
    freecadWayland = pkgs.symlinkJoin {
      name = "freecad-wayland-fix";
      paths = [
        pkgs.freecad-wayland
      ];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/FreeCAD \
          --prefix MESA_LOADER_DRIVER_OVERRIDE : zink \
          --prefix __EGL_VENDOR_LIBRARY_FILENAMES : ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
      '';
    };
  in {
    environment.systemPackages = with pkgs; [
      qbittorrent
      vlc
      pear-desktop
      freecadWayland
      orca-slicer
      (mpv.override {
        scripts = [
          pkgs.mpvScripts.uosc
        ];
      })
    ];
  };
}
