{
  lib,
  pkgs,
  ...
}: {
  programs.zoxide.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.mkAfter ''
      set -g fish_greeting
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
      set -gx FZF_DEFAULT_OPTS '--layout=reverse --border --height=80%'
      set -gx FZF_CTRL_R_COMMAND ""
      # Atuin owns Ctrl-R; fzf supplies file and directory widgets only.
      fzf --fish | source
    '';
    shellAliases = {
      ll = "eza --long --all --group-directories-first";
      lg = "lazygit";
    };
    shellAbbrs = {
      gs = "git status --short --branch";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate -20";
    };
    shellFunctions = {
      cdf.body = ''
        set -l dir (fd --type d --hidden --exclude .git --print0 | fzf --read0 --print0 | string split0)
        test -n "$dir"; and cd -- "$dir"
      '';
      fe.body = ''
        set -l files (fd --type f --hidden --exclude .git --print0 | fzf --read0 --print0 --multi --preview 'bat --color=always --style=numbers -- {}' | string split0)
        if test (count $files) -gt 0
          set -l editor (string split ' ' -- "$EDITOR")
          test (count $editor) -gt 0; or set editor nano
          $editor -- $files
        end
      '';
      # Pick a file containing matching text. Multi-line filenames remain intact.
      rge.body = ''
        if test (count $argv) -eq 0
          echo 'Usage: rge <ripgrep pattern>'
          return 2
        end
        set -l files (rg --files-with-matches --null --hidden --glob '!.git' -- "$argv[1]" | fzf --read0 --print0 --multi --preview 'bat --color=always --style=numbers -- {}' | string split0)
        if test (count $files) -gt 0
          set -l editor (string split ' ' -- "$EDITOR")
          test (count $editor) -gt 0; or set editor nano
          $editor -- $files
        end
      '';
      y.body = ''
        set -l cwdfile (mktemp)
        command yazi --cwd-file="$cwdfile" $argv
        set -l result $status
        set -l cwd (string collect < "$cwdfile")
        rm -f -- "$cwdfile"
        if test -n "$cwd"; and test "$cwd" != "$PWD"
          cd -- "$cwd"
        end
        return $result
      '';
      croot.body = ''
        set -l root (git rev-parse --show-toplevel 2>/dev/null)
        test -n "$root"; and cd -- "$root"
      '';
    };
  };
  # WSL has no enabled Neovim module; retain a usable editor there.
  environment.systemPackages = [pkgs.nano];
  environment.variables.EDITOR = lib.mkDefault "nano";
}
