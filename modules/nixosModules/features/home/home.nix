{config, ...}: {
  hjem.users.${config.nixconf.user.name} = {
    directory = "/home/${config.nixconf.user.name}";
    clobberFiles = true;
    files.".config/niri/config.kdl".source = ./niri/config.kdl;
  };
}
