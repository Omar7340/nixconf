{
  networking.hostName = "tower";
  users.users.kage = {
    isNormalUser = true;
    description = "Kage";
    extraGroups = ["networkmanager" "wheel"];
  };
  system.stateVersion = "25.05";
}
