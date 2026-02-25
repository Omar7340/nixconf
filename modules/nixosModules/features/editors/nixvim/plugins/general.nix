{
  flake.nixosModules.nixvim = {...}: {
    programs.nixvim = {
      keymaps = [
        {
          key = "<leader><leader>";
          action.__raw = ''
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                current_line_only = true
              })
            end
          '';
          options.remap = true;
        }
        {
          key = "<leader>e";
          action = "<cmd>Oil<CR>";
          options.desc = "Open File Explorer (Oil)";
        }
        {
          key = "<leader>gg";
          action = "<cmd>LazyGit<CR>";
        }
      ];

      colorschemes.everforest = {
        enable = true;
        autoLoad = true;
      };

      plugins = {
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

        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };

        lazygit.enable = true;
        hop.enable = true;

        oil = {
          enable = true;

          settings = {
            default_file_explorer = true;
            watch_for_changes = false;
            columns = ["icon"];
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
