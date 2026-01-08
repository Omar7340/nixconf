{ ... }:
{
  environment.shellAliases = {
    ll = "ls -al";
    cdc = "cd /etc/nixos";
    econf = "nvim /etc/nixos"; # Edit configuration (use sudo if not root)
    rebuild = "nixos-rebuild switch --flake";
  };
}
