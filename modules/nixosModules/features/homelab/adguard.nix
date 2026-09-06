{config, ...}: {
  services.adguardhome = {
    enable = true;
    openFirewall = false;
    mutableSettings = false;
    settings = {
      language = "fr";
      theme = "dark";
      dns = {
        upstream_dns = [
          "h3://1.1.1.1/dns-query"
          "h3://1.0.0.1/dns-query"
          "https://dns.google/dns-query"
        ];
        bootstrap_dns = ["1.1.1.1" "9.9.9.9" "8.8.8.8"];
        use_http3_upstreams = true;
        upstream_mode = "parallel";
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        rewrites = [
          {
            domain = "*.${config.homelab.domain}";
            answer = config.homelab.address;
            enabled = true;
          }
        ];
      };
      filters =
        map (url: {
          enabled = true;
          inherit url;
        }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
          "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
          "https://easylist.to/easylist/easylist.txt"
          "https://easylist.to/easylist/easyprivacy.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.apple.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.winoffice.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.samsung.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.amazon.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.huawei.txt"
          "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.xiaomi.txt"
          "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt"
        ];
    };
  };
}
