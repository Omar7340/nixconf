{pkgs, ...}: let
  kitty = pkgs.symlinkJoin {
    name = "kitty-configured";
    paths = [pkgs.kitty];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/kitty --add-flags "--config ${./kitty.conf}"
    '';
  };
in {
  # Fish must not emit Stylix's desktop palette over Kitty's Tokyo Night colors.
  stylix.targets.fish.enable = false;
  environment.systemPackages = [kitty];
}
