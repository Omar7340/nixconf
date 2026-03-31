{ self, ... }:
{
  flake.nixosModules.dev =
    { pkgs, ... }:
    {
      imports = [
        # self.nixosModules.nvf
        self.nixosModules.nixvim
        self.nixosModules.helix
      ];
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
