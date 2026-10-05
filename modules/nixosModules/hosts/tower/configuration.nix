{
  config,
  lib,
  ...
}: {
  nixconf.desktop.session = "niri";
  specialisation.KDE.configuration = {
    nixconf.desktop.session = lib.mkForce "plasma";
    system.nixos.tags = ["KDE"];
  };
  environment.etc."niri-desktop/outputs.kdl".source = ./niri-outputs.kdl;
  nix.settings.secret-key-files = ["/var/lib/nix-signing/tower-1.sec"];
  networking = {
    hostName = "tower";
    firewall.allowedUDPPorts = [config.services.tailscale.port];
    hosts."100.98.91.45" = [
      "ad.babel.local"
      "bd.babel.local"
      "hp.babel.local"
      "jf.babel.local"
    ];
  };
  security.pki.certificateFiles = [../../../../certificates/babel-caddy-root.crt];
  services.tailscale.enable = true;
  users.users.kage = {
    isNormalUser = true;
    description = "Kage";
    extraGroups = ["networkmanager" "wheel"];
  };
  system.stateVersion = "25.05";
}
