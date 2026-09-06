{config, ...}: let
  user = config.nixconf.user;
in {
  programs.git = {
    enable = true;
    config = {
      user = {
        inherit (user) name email;
      };
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}
