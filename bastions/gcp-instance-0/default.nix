{ hostName, ... }:
{
  imports = [
    ./caddy
    ./subgen
    ./chinadns
  ];
  virtualisation.docker.enable = false;

  services.self-hosted.o11y = {
    inherit hostName;
    enable = true;
  };

  services.self-hosted.cloud.sing-box.enable = true;

  services.self-hosted.unguarded.enable = true;
}
