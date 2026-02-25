{
  flake.nixosModules.nixvim =
    { ... }:
    {
      programs.nixvim = {
        luaLoader.enable = true;

        performance = {
          combinePlugins = {
            enable = true;
            standalonePlugins = [
              "neorg"
              "nvim-treesitter"
              "lualine.nvim"
              "oil.nvim"

              # `queries/lua/highlights.scm` conflicts with nvim-treesitter-grammars
              "snacks.nvim"

              # `.gitignore` conflicts with blink-cmp
              "typst-preview.nvim"
            ];
          };
          byteCompileLua.enable = true;
        };

        globals = {
          # Disable useless providers
          loaded_ruby_provider = 0; # Ruby
          loaded_perl_provider = 0; # Perl
          loaded_python_provider = 0; # Python 2
        };
      };
    };
}
