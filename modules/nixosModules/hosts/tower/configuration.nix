{config, ...}: {
  nix.settings.secret-key-files = ["/var/lib/nix-signing/tower-1.sec"];
  networking = {
    hostName = "tower";
    firewall.allowedUDPPorts = [config.services.tailscale.port];
  };
  services.tailscale.enable = true;
  users.users.kage = {
    isNormalUser = true;
    description = "Kage";
    extraGroups = ["networkmanager" "wheel"];
  };
  system.stateVersion = "25.05";
}
