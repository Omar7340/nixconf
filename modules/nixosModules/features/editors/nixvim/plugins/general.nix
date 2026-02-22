{
  flake.nixosModules.nixvim =
    { ... }:
    {
      programs.nixvim = {

        colorschemes.everforest = {
          enable = true;
          autoLoad = true;
        };

        plugins = {
          # Lazy loading
          lz-n.enable = true;

          web-devicons.enable = true;
          which-key = {
            enable = true;
            autoLoad = true;
          };

          gitsigns = {
            enable = true;
            settings.signs = {
              add.text = "+";
              change.text = "~";
            };
          };

          nvim-autopairs.enable = true;

          colorizer = {
            enable = true;
            settings.user_default_options.names = false;
          };

          oil = {
            enable = true;
            lazyLoad.settings.cmd = "Oil";

            settings = {
              default_file_explorer = true;
              watch_for_changes = false;
              columns = [ "icon" ];
              view_options = {
                show_hidden = true;
              };
            };
          };

          trim = {
            enable = true;
            settings = {
              highlight = true;
              ft_blocklist = [
                "checkhealth"
                "floaterm"
                "lspinfo"
                "neo-tree"
                "TelescopePrompt"
              ];
            };
          };
        };
      };
    };
}
