{
  flake.nixosModules.nixvim = {
    programs.nixvim = {
      keymaps = [
        {
          mode = "n";
          key = "<C-g>";
          action = ":Neorg toc<CR>";
          options.silent = true;
        }
      ];

      plugins.neorg = {
        enable = true;
        telescopeIntegration.enable = true;

        settings = {
          load = {
            "core.dirman" = {
              config = {
                workspaces = {
                  perso = "~/Notes/perso";
                };
              };
            };
          };
        };
      };
    };
  };
}
