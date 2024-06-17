{ ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 13000;
      };
    };
  };

  services.loki = {
    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 0;
        grpc_listen_port = 0;
      };
      clients = [{
        url = "http://127.0.0.1:3100/loki/api/v1/push";
      }];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            json = false;
            max_age = "12h";
            path = "/var/log/journal";
            labels = {
              job = "systemd-journal";
            };
          };
          relabel_configs = [
            {
              source_labels = [
                "__journal__systemd_unit"
              ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
