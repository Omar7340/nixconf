{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.okular
    xournalpp
    pdfarranger
    libreoffice-qt-stable
    calibre
  ];
}
