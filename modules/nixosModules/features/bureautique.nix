{
  flake.nixosModules.bureautique = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.okular
      libreoffice-qt-fresh
    ];
  };
}
