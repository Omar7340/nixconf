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
        format = "binary";

        owner = "root";
        mode = "0400";
      };

    };
}
