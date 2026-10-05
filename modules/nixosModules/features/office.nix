{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obsidian
    kdePackages.okular
    xournalpp
    pdfarranger
    libreoffice-qt-stable
    calibre
  ];
}
