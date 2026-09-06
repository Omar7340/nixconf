{
  environment.shellAliases = {
    ll = "ls -al";
    cdc = "cd /etc/nixos";
    econf = "cdc && nvim /etc/nixos";
    rebuild = "nh os switch";
    ni = "nix-inspect";
  };
}
