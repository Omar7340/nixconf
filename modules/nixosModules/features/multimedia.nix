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

    # FIX Use PR for now. still being reviewed
    # issue: https://github.com/NixOS/nixpkgs/pull/495746
    nixpkgs-495746-drv = pkgs.applyPatches {
      src = pkgs.path;
      patches = [
        (pkgs.fetchpatch2 {
          url = "https://github.com/NixOS/nixpkgs/pull/495746.patch";
          sha256 = "sha256-RjJp56dXGPRBPQNWdBe/Je8yMRsrteWhNM9yZ6cDo7Y=";
        })
      ];
    };
    nixpkgs-495746 = import nixpkgs-495746-drv {
      inherit (pkgs.stdenv) system;
      config.allowUnfree = true;
    };
  in {
    environment.systemPackages = with pkgs; [
      qbittorrent
      vlc
      pear-desktop
      freecadWayland
      nixpkgs-495746.orca-slicer
      (mpv.override {
        scripts = [
          pkgs.mpvScripts.uosc
        ];
      })
    ];
  };
}
