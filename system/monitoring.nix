{ config
, ...
}: {
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
    scrapeConfigs = [{
      job_name = "node";
      static_configs = [{
        targets =
          let
            inherit (config.services.prometheus.exporters.node) listenAddress port;
          in
          [ "${toString listenAddress}:${toString port}" ];
      }];
      scrape_interval = "30s";
    }];
  };
}
