{ pkgs, config, lib, ... } :

{
    environment.systemPackages = with pkgs; [
        youtube-music
        vscode
        bitwarden-desktop
    ];
}