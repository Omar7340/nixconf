{
  flake.nixosModules.browsers =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        homepageLocation = "https://www.google.com";

      };

      # Correcteur orthographique système
      environment.systemPackages = with pkgs; [
        ungoogled-chromium
      ];
    };
}
