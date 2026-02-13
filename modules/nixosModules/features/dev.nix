{ self, ... }:
{
  flake.nixosModules.dev =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.nvf
      ];
      environment.systemPackages = with pkgs; [
        yazi
        btop
      ];
    };
}
