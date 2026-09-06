{
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };
  networking.hostName = "wsl";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
