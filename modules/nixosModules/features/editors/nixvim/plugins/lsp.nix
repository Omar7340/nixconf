{
  flake.nixosModules.nixvim = {lib, ...}: {
    programs.nixvim = {
      diagnostic.settings.virtual_text = true;

      lsp = {
        inlayHints.enable = true;
        servers = {
          lua_ls = {
            enable = true;
            config.settings.diagnostics.globals = ["vim"];
          };
        };

        keymaps =
          lib.mapAttrsToList
          (
            key: props:
              {
                inherit key;
                options.silent = true;
              }
              // props
          )
          {
            "<leader>k".action.__raw = "function() vim.diagnostic.jump({ count=-1, float=true }) end";
            "<leader>j".action.__raw = "function() vim.diagnostic.jump({ count=1, float=true }) end";
            gd.lspBufAction = "definition";
            gD.lspBufAction = "references";
            gt.lspBufAction = "type_definition";
            gi.lspBufAction = "implementation";
            K.lspBufAction = "hover";
            "<F2>".lspBufAction = "rename";
            "<leader>f".lspBufAction = "format";
          };
      };

      plugins = {
        conform-nvim = {
          enable = true;
          autoInstall = {
            enable = true;
            enableWarnings = true;
          };
          settings = {
            format_on_save = {
              lspFallback = true;
              timeoutMs = 500;
            };
            formatters_by_ft = {
              nix = ["alejandra"];
            };
          };
        };
        lsp-format = {
          enable = true;
          lspServersToEnable = "all";
        };

        # Sane defaults for all servers
        lspconfig.enable = true;
      };
    };
  };
}
