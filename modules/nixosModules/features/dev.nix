{
  flake.nixosModules.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yazi
        btop
      ];
    };
}
