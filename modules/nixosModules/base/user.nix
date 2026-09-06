{lib, ...}: {
  options.nixconf.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "kage";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "kage@localhost.local";
    };
  };
}
