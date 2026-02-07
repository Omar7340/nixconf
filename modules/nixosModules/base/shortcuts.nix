{
  flake.nixosModules.base =
    { ... }:
    {
      environment.shellAliases = {
        ll = "ls -al";
        cdc = "cd /etc/nixos";
        econf = "cdc && nvim /etc/nixos"; # Edit configuration (use sudo if not root)
        rebuild = "nh os switch";
        ni = "nix-inspect";
      };
    };
}
