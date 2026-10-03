{
  environment.shellAliases = {
    ll = "ls -al";
    cdc = "cd /etc/nixos";
    econf = "cdc && $EDITOR /etc/nixos/flake.nix";
    ni = "nix-inspect";
  };
}
