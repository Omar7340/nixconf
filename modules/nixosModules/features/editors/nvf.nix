{
  programs.nvf = {
    enable = false;
    settings.vim = {
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
      lsp = {
        enable = true;
        formatOnSave = true;
      };
      notes.neorg = {
        treesitter.enable = true;
        setupOpts.load."core-default".enable = true;
      };
      treesitter = {
        enable = true;
        context.enable = true;
      };
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
      utility = {
        oil-nvim = {
          enable = true;
          gitStatus.enable = true;
        };
        motion.hop = {
          enable = true;
          mappings.hop = "<Leader><Leader>";
        };
      };
      git = {
        enable = true;
        gitsigns.enable = true;
      };
      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
      binds.whichKey.enable = true;
      options = {
        tabstop = 2;
        shiftwidth = 2;
        autoindent = true;
      };
    };
  };
}
