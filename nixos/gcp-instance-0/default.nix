{ ... }: {
  imports = [
    ./caddy
    ./subgen
    ./chinadns
  ];
  virtualisation.docker.enable = false;

  services.self-hosted.o11y = {
    enable = true;
    hostName = "gcp-instance-0";
  };

  services.self-hosted.cloud.sing-box.enable = true;

  services.self-hosted.unguarded.enable = true;
}
