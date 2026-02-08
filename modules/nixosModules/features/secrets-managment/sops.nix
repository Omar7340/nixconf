{ inputs, ... }:
{
  flake.nixosModules.secrets-managment =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops.secrets.wg_conf = {
        sopsFile = "${inputs.self}/secrets/wg.conf.enc";
        key = "data";
        format = "yaml";
        owner = "root";
        mode = "0400";
      };

    };
}
