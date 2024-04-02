{ ... }: {
  virtualisation.docker.enable = true;

  services.self-hosted.o11y = {
    enable = true;
    hostName = "gcp-instance-1";
  };

  services.self-hosted.cloud.sing-box = {
    enable = true;
    ingress = 10080;
  };
}
