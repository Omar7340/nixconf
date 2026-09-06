{pkgs, ...}: {
  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };
  environment.systemPackages = with pkgs; [
    zellij
    lazygit
    yazi
    btop
    kitty
  ];
}
