{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.desktop = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.hjem.nixosModules.default
      inputs.stylix.nixosModules.stylix
      self.nixosModules.browsers
      self.nixosModules.theme
      self.nixosModules.home
      self.nixosModules.bureautique
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      corefonts
      unifont
    ];

    # needed for noctalia
    #programs.niri.enable = true;
    #services.upower.enable = true;
    #services.tuned.enable = true;

    # Enable Plasma
    services.desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    services.displayManager.sddm = {
      enable = true;

      # To use Wayland (Experimental for SDDM)
      wayland.enable = true;
    };

    # Optionally enable xserver
    services.xserver.enable = true;

    hardware.i2c.enable = true;
    users.users.${config.preferences.user.name}.extraGroups = ["i2c"];

    # Enable networking
    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      alacritty
      woomer
      bibata-cursors
    ];
  };
}
