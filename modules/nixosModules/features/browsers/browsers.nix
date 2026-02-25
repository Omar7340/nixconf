{
  flake.nixosModules.browsers =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        extraOpts = {
          "BrowserSignin" = 0;
          "DnsOverHttpsMode" = "secure";
          "DnsOverHttpsTemplates" = "https://dns.cloudflare.com/dns-query";
          "SyncDisabled" = true;
          "PasswordManagerEnabled" = false;
          "SpellcheckEnabled" = true;
          "SpellcheckLanguage" = [
            "fr"
            "en-US"
          ];
        };

        extensions = [
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
        ];
      };
      environment.etc."/brave/policies/managed/GroupPolicy.json".source = ./policies.json;

      environment.systemPackages = [
        pkgs.brave
      ];
    };
}
