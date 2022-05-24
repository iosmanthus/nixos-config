{ ... }: {
  sops.secrets.v2ray-config = {
    format = "binary";
    sopsFile = ./v2ray_config;
  };

  sops.secrets.clash-config = {
    format = "binary";
    sopsFile = ./clash_config;
  };
}
