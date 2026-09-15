{
  nix.settings.secret-key-files = ["/var/lib/nix-signing/tower-1.sec"];
  networking.hostName = "tower";
  users.users.kage = {
    isNormalUser = true;
    description = "Kage";
    extraGroups = ["networkmanager" "wheel"];
  };
  system.stateVersion = "25.05";
}
