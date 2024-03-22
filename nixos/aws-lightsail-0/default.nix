{ pkgs
, modulesPath
, lib
, ...
}:
{
  imports = [
    ./atuin
    ./caddy
    ./chatgpt-next-web
    ./one-api
    ./subgen
    ./vaultwarden
  ];

  networking.timeServers = [
    "time.aws.com"
  ];

  services.timesyncd = {
    enable = true;
    extraConfig = ''
      PollIntervalMinSec=30
      PollIntervalMaxSec=60
    '';
  };

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };

  virtualisation.docker.enable = true;

  services.self-hosted.o11y = {
    hostName = "aws-lightsail-0";
    enable = true;
  };

  services.self-hosted.cloud.sing-box = {
    enable = true;
    ingress = 10080;
  };
}
