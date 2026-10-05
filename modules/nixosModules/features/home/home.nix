{
  config,
  lib,
  ...
}: {
  hjem.users.${config.nixconf.user.name} = {
    directory = "/home/${config.nixconf.user.name}";
    clobberFiles = true;
    files.".config/niri/config.kdl" = lib.mkIf (config.nixconf.desktop.session == "niri") {
      source = ./niri/config.kdl;
    };
  };
}
