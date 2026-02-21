{ inputs, self, ... }:
{
  flake.wrappers.neovim =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.neovim ];

      settings.config_directory = ./config;
      settings.aliases = [
        "vim"
        "vi"
      ];

      specs.initLua = {
        data = null;
        before = [ "MAIN_INIT" ];
        config = ''
          require('init')
          require('lz.n').load('plugins')
        '';
      };

      specs.general = with pkgs.vimPlugins; [
        lz-n

        # utils
        plenary-nvim
        telescope-nvim
        oil-nvim
        which-key-nvim

        # lsp
        nvim-lspconfig
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars

        # visual
        nvim-web-devicons
        oxocarbon-nvim
        lualine-nvim
      ];

      extraPackages = with pkgs; [
        lazygit
        tree-sitter
        ripgrep
        fzf
        fd
        alejandra
      ];
    };

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.neovim = inputs.wrappers.wrappers.neovim.wrap {
        inherit pkgs;
        imports = [ self.wrappers.neovim ];
      };
    };
}
