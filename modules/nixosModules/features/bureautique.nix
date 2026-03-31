{
  flake.nixosModules.bureautique = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.okular
      xournalpp
      pdfarranger
      libreoffice-qt-fresh
      calibre
    ];
  };
}
