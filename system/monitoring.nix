{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9090;
    exporters = {
      node = {
        enabledCollectors = [ "systemd" ];
        disabledCollectors = [ "rapl" ];
        listenAddress = "127.0.0.1";
        enable = true;
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = let
              listenAddress = config.services.prometheus.exporters.node.listenAddress;
              port = config.services.prometheus.exporters.node.port;
            in
              [
                "${toString listenAddress}:${toString port}"
              ];
          }
        ];
        scrape_interval = "30s";
      }
    ];
  };
}
