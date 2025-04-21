{ pkgs, config, lib, ... } :

{
    environment.systemPackages = with pkgs; [
        git
        zellij
    ];
}