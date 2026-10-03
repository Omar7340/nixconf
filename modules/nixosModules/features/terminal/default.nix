{pkgs, ...}: {
  imports = [./shell.nix ./prompt.nix ./workflow.nix];

  environment.systemPackages = with pkgs; [
    fzf
    fd
    ripgrep
    bat
    eza
    jq
    yazi
    lazygit
    btop
  ];
}
