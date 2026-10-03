{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$python$nodejs$cmd_duration$status$line_break$character";
      directory = {
        style = "bold blue";
        truncation_length = 3;
      };
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      git_status.style = "yellow";
      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) ";
      };
      username = {
        show_always = false;
        format = "[$user@]($style)";
      };
      nix_shell = {
        symbol = "nix ";
        format = "[$symbol$state]($style) ";
      };
      python = {
        symbol = "py ";
        format = "[$symbol$pyenv_prefix($version )(\\($virtualenv\\) )]($style)";
      };
      nodejs = {
        symbol = "node ";
        format = "[$symbol($version )]($style)";
      };
      cmd_duration = {
        min_time = 2000;
        format = "[took $duration]($style) ";
      };
      status = {
        disabled = false;
        format = "[exit $status]($style) ";
      };
      character = {
        success_symbol = "[❯](bold cyan)";
        error_symbol = "[❯](bold red)";
      };
    };
  };
}
