{ self, ... }:
{
  flake.nixosModules.dev =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.nvf
        self.nixosModules.helix
      ];
      environment.systemPackages = with pkgs; [
        zellij
        lazygit
        yazi
        btop
        self.packages.${pkgs.system}.neovim
      ];
    };
}
