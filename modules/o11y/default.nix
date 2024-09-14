{ config, lib, ... }:
with lib;
let
  cfg = config.services.self-hosted.o11y;

  gatewayConfiguration = ''
    log {
      level ERROR
    }

    route /promtail/* {
      uri strip_prefix /promtail
      reverse_proxy https://logs-prod-020.grafana.net {
        header_up Host logs-prod-020.grafana.net
        header_up Authorization "Basic {env.PROMTAIL_BASIC_AUTH}"
      }
    }

    route /prometheus/* {
      uri strip_prefix /prometheus
      reverse_proxy https://prometheus-prod-37-prod-ap-southeast-1.grafana.net {
        header_up Host prometheus-prod-37-prod-ap-southeast-1.grafana.net
        header_up Authorization "Basic {env.PROMETHEUS_BASIC_AUTH}"
      }
    }
  '';

  caddyEnv = ''
    PROMTAIL_BASIC_AUTH=${config.sops.placeholder."grafana/promtail-basic-auth"}
    PROMETHEUS_BASIC_AUTH=${config.sops.placeholder."grafana/prometheus-basic-auth"}
  '';

  promtailConfiguration = {
    server = {
      http_listen_port = 0;
      grpc_listen_port = 0;
    };
    clients = [
      {
        url = "http://127.0.0.1:${cfg.grafanaCloudGateway}/promtail/loki/api/v1/push";
      }
    ];
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
            source_labels = [ "__journal__hostname" ];
            target_label = "host";
            replacement = cfg.hostName;
          }
          {
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }
        ];
      }
    ];
  };

  # Prometheus configuration
  exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9002;
    };
  };

  scrapeConfigs = [
    {
      job_name = "systemd";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          ];
        }
      ];
      relabel_configs = [
        {
          source_labels = [ "__address__" ];
          target_label = "instance";
          replacement = cfg.hostName;
        }
      ];
    }
  ];

  remoteWrite = [
    {
      url = "http://127.0.0.1:${cfg.grafanaCloudGateway}/prometheus/api/prom/push";
    }
  ];
in
{
  options.services.self-hosted.o11y = {
    enable = mkEnableOption "enable self-hosted o11y";

    grafanaCloudGateway = mkOption {
      type = types.str;
      default = "8080";
      description = "The local gateway address to Grafana Cloud";
    };

    hostName = mkOption {
      type = types.str;
      description = "The hostname to use for the services";
    };
  };

  config = mkIf cfg.enable {
    sops.templates."caddy.env" = {
      content = caddyEnv;
    };

    systemd.services.caddy = {
      restartTriggers = [ config.sops.templates."caddy.env".content ];

      serviceConfig = {
        EnvironmentFile = [ config.sops.templates."caddy.env".path ];
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        ":${cfg.grafanaCloudGateway}" = {
          extraConfig = gatewayConfiguration;
        };
      };
    };

    services.promtail = {
      enable = true;
      configuration = promtailConfiguration;
    };

    services.prometheus = {
      enable = true;
      inherit exporters scrapeConfigs remoteWrite;
    };
  };
}
