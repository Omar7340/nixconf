{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    nixpkgs.source = pkgs.path;
    clipboard.register = "unnamedplus";
  };
}
