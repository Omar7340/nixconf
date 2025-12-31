{config, pkgs, ...}:
{
  programs.nvf = {
    enable = true;
  
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        theme = {
            enable = true;
            name = "tokyonight";
            style = "storm";
        };
        viAlias = true;
        vimAlias = true;

        lsp.enable = true;
        telescope.enable = true;

        binds = {
          whichKey.enable = true;
        };

        options = {
          shiftwidth = 4;
        };
      };
    };
  };
}
