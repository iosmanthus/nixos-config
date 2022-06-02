{ ... }: 

let 
  hashFiles = builtins.map (builtins.hashFile "sha256");
in
{
  sops.secrets.v2ray-config = {
    format = "binary";
    sopsFile = ./v2ray_config;
  };

  sops.secrets.clash-config = {
    format = "binary";
    sopsFile = ./clash_config;
  };

  systemd.services.docker-clash.restartTriggers = hashFiles [
    ./clash_config
  ];

  systemd.services.docker-v2ray.restartTriggers = hashFiles [
    ./v2ray_config
  ];
}
