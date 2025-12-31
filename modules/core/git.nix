{config, pkgs, ...}:
{
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Om";
          email = "Om@babel.local";
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
}
