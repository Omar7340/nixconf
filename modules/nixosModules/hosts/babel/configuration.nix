{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking = {
    hostName = "babel";
    networkmanager.enable = true;
    nameservers = ["127.0.0.1"];
  };
  services = {
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
        Domains = ["~."];
        FallbackDNS = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        DNSOverTLS = "true";
      };
    };
    tailscale.enable = true;
  };
  nixconf.user.name = "babel";
  users.users.babel = {
    isNormalUser = true;
    description = "babel";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEp5ExRYPh7Jl+YVTrigl+emwUcQwAGGfeM/C5SqRKoo kage@tower"
    ];
  };
  system.stateVersion = "25.05";
}
