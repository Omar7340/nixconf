{ config, pkgs, ... }:
{
  programs.nvf = {
    enable = true;

    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        theme = {
          enable = true;
          #            name = "tokyonight";
          #            style = "storm";
          name = "oxocarbon";
          style = "dark";
        };

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
        };

        statusline.lualine.enable = true;

        filetree.nvimTree.enable = false;
        telescope.enable = true;

        viAlias = true;
        vimAlias = true;

        lsp.enable = true;
        lsp.formatOnSave = true;

        treesitter.enable = true;
        treesitter.context.enable = true;
        languages = {
          enableTreesitter = true;

          nix.enable = true;
          yaml.enable = true;
          typst.enable = true;
        };

        autocomplete.nvim-cmp.enable = true;

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
          shiftwidth = 2;
        };

      };
    };
  };
}
