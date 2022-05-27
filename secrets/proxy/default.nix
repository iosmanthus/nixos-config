{ ... }: {
  sops.secrets.v2ray-config = {
    format = "binary";
    sopsFile = ./v2ray_config;
  };

  sops.secrets.clash-config = {
    format = "binary";
    sopsFile = ./clash_config;
  };

  systemd.services.docker-clash.restartTriggers = [
    ./clash_config
  ];

  systemd.services.docker-v2ray.restartTriggers = [
    ./v2ray_config
  ];
}
