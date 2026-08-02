{self, ...}: {
  flake.nixosModules.dev = {pkgs, ...}: {
    imports = [
      # self.nixosModules.nvf
      self.nixosModules.nixvim
      self.nixosModules.helix
    ];

    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
    };

    environment.systemPackages = with pkgs; [
      zellij
      lazygit
      yazi
      btop
      kitty
      # self.packages.${pkgs.system}.neovim
    ];
  };
}
