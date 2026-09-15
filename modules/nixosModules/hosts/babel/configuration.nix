{
  nix.settings.trusted-public-keys = [
    "tower-1:aSZ2IiDaqfNxYi5Cg2e9iYtpd3Aln3c+UNA2jlZcTa0="
  ];
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
    tailscale.enable = true;
  };
  security.sudo.wheelNeedsPassword = false;
  nixconf.user.name = "babel";
  users.users.babel = {
    isNormalUser = true;
    description = "babel";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEp5ExRYPh7Jl+YVTrigl+emwUcQwAGGfeM/C5SqRKoo kage@tower"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1NRQDfwKv3E43QSay6Aiqh9vlNOFAGpZvAbrW0Oi1A root@tower"
    ];
  };
  system.stateVersion = "25.05";
}
