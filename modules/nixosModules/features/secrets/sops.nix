{
  sops.secrets.wireguardConfig = {
    sopsFile = ../../../../secrets/wg.conf.enc;
    key = "data";
    format = "yaml";
    owner = "root";
    mode = "0400";
  };
}
