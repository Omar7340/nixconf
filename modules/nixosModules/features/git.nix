{ inputs, ... }:
{
  flake.nixosModules.git =
    { config, ... }:
    let
      user = config.preferences.user;
    in
    {
      programs.git = {
        enable = true;
        config = {
          user = {
            name = user.name;
            email = user.mail;
          };
          init = {
            defaultBranch = "main";
          };
          # Optionnel : pour que Git utilise l'agent SSH du système
          core = {
            sshCommand = "ssh -i ~/.ssh/id_ed25519";
          };
          safe = {
            # Évite les erreurs de permissions sur les dépôts appartenant à root
            directory = "/etc/nixos";
          };
        };
      };
      services.openssh.enable = true;

    };
}
