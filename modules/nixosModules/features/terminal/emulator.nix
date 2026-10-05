{
  pkgs,
  config,
  ...
}: let
  kittyConfig =
    if config.nixconf.desktop.session == "niri"
    then
      pkgs.writeText "kitty-niri.conf" ''
        include ${./kitty.conf}
        include ~/.local/state/niri-desktop/theme/kitty.conf
      ''
    else ./kitty.conf;
  kitty = pkgs.symlinkJoin {
    name = "kitty-configured";
    paths = [pkgs.kitty];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/kitty --add-flags "--config ${kittyConfig}"
    '';
  };
in {
  # Fish must not emit Stylix's desktop palette over Kitty's Tokyo Night colors.
  stylix.targets.fish.enable = false;
  environment.systemPackages = [kitty];
}
