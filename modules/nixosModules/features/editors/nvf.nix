{ inputs, ... }:
{
  flake.nixosModules.nvf =
    { pkgs, ... }:
    {
      imports = [ inputs.nvf.nixosModules.default ];
      programs.nvf = {
        # enable = true;

        # Your settings need to go into the settings attribute set
        # most settings are documented in the appendix
        settings = {
          vim = {
            theme = {
              enable = true;
              name = "oxocarbon";
              style = "dark";
            };

            visuals = {
              nvim-web-devicons.enable = true;
              nvim-cursorline.enable = true;
              indent-blankline.enable = true;
            };

            statusline.lualine.enable = true;

            filetree.nvimTree.enable = false;
            telescope.enable = true;

            viAlias = true;
            vimAlias = true;

            lsp.enable = true;
            lsp.formatOnSave = true;

            notes.neorg = {
              treesitter.enable = true;
              setupOpts.load."core-default".enable = true;
            };

            treesitter.enable = true;
            treesitter.context.enable = true;
            languages = {
              enableTreesitter = true;

              nix.enable = true;
              yaml.enable = true;
              typst.enable = true;
              html.enable = true;
              json.enable = true;
              python.enable = true;
              ts.enable = true;
            };

            autocomplete.nvim-cmp.enable = true;
            autopairs.nvim-autopairs.enable = true;

            utility.oil-nvim.enable = true;
            utility.oil-nvim.gitStatus.enable = true;
            utility.motion.hop.enable = true;
            utility.motion.hop.mappings.hop = "<Leader><Leader>";

            git = {
              enable = true;
              gitsigns.enable = true;
            };

            terminal = {
              toggleterm = {
                enable = true;
                lazygit.enable = true;
              };
            };

            binds = {
              whichKey.enable = true;
            };

            options = {
              tabstop = 2;
              shiftwidth = 2;
              autoindent = true;
            };

          };
        };
      };
    };
}
