{
  nixarr = {
    enable = true;
    mediaDir = "/mnt/media/nixarr";
    stateDir = "/mnt/media/nixarr/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = "/data/.secret/vpn/wg.conf";
    };

    jellyfin = {
      enable = true;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 54734; # Set this to the port forwarded by your VPN
    };
  };
}
