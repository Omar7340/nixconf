{
  config,
  lib,
  ...
}: {
  hjem.users.${config.nixconf.user.name} = {
    directory = "/home/${config.nixconf.user.name}";
    clobberFiles = true;
    files.".config/hypr/hyprland.lua" = lib.mkIf (config.nixconf.desktop.session == "hyprland") {
      source = ./hyprland/hyprland.lua;
    };
    files.".config/niri/config.kdl" = lib.mkIf (config.nixconf.desktop.session == "niri") {
      source = ./niri/config.kdl;
    };
  };
}
