{ hostName, ... }:
{
  imports = [
    ./atuin
    ./caddy
    ./vaultwarden
  ];

  networking.timeServers = [ "time.aws.com" ];

  services.timesyncd = {
    enable = true;
    extraConfig = ''
      PollIntervalMinSec=30
      PollIntervalMaxSec=60
    '';
  };

  virtualisation.docker.enable = true;

  services.self-hosted.o11y = {
    inherit hostName;
    enable = true;
  };

  services.self-hosted.cloud.sing-box.enable = true;

  services.self-hosted.gemini-openai-proxy = {
    enable = true;
    port = 5680;
  };
}
