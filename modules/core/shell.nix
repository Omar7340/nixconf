{ ... }:
{
  environment.shellAliases = {
    ll = "ls -al";
    econf = "nvim /etc/nixos"; # Edit configuration (use sudo if not root)
    rebuild = "nixos-rebuild switch --flake";
  };
}
