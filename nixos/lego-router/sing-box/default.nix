{ config
, ...
}: {
  sops.templates."sing-box-updater.env".content = ''
    URL=${config.sops.placeholder.sing-box-url}
  '';

  services.self-hosted.sing-box = {
    enable = true;
    configFile = "/var/lib/sing-box/config.json";
    autoUpdate = {
      enable = true;
      interval = "15m";
      environmentFile = config.sops.templates."sing-box-updater.env".path;
    };
  };
}
