{
  pkgs,
  config,
  ...
}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    corefonts
    unifont
  ];
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver.enable = true;
  };
  programs.kdeconnect.enable = true;
  hardware.i2c.enable = true;
  users.users.${config.nixconf.user.name}.extraGroups = ["i2c"];
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty
    bibata-cursors
    kdePackages.kamoso
    kdePackages.plasma-browser-integration
  ];
}
