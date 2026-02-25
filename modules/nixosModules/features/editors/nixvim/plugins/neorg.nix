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
        {
          mode = "n";
          key = "<leader>gp";
          action = ":Neorg workspace perso<CR>";
          options.desc = "Go to Personal Notes Workspaces (Neorg)";
        }
      ];

      plugins.neorg = {
        enable = true;
        telescopeIntegration.enable = true;

        settings = let
          personal_workspace = "perso";
        in {
          load = {
            "core.concealer" = {
              config = {
                icon_preset = "varied";
              };
            };
            "core.defaults" = {
              __empty = null;
            };
            "core.dirman" = {
              config = {
                workspaces = {
                  "${personal_workspace}" = "~/Notes/${personal_workspace}";
                };
                default_workspace = "${personal_workspace}";
              };
            };
            "core.journal" = {
              config = {
                journal_folder = "journal";
                strategy = "flat";
                workspace = "${personal_workspace}";
              };
            };
          };
        };
      };
    };
  };
}
