{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    nixpkgs.source = pkgs.path;
    clipboard.register = "unnamedplus";
    extraConfigLua = builtins.readFile ../../../../wrappedPrograms/neovim/config/lua/wallpaper.lua;
  };
}
