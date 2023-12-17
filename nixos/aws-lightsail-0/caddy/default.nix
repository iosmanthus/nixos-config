{ config
, ...
}: {
  iosmanthus.caddy = {
    enable = true;
    configFile = config.sops.templates."Caddyfile".path;
  };

  systemd.services.caddy.restartTriggers = [
    config.sops.templates."Caddyfile".content
  ];

  networking.firewall.allowedTCPPorts = [ 443 ];

  sops.templates."Caddyfile" = {
    owner = config.iosmanthus.caddy.user;
    content = ''
      ${config.sops.placeholder."caddy/virtual-host-a"} {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare-api-token"}
        }
        log {
          level INFO
        }
        reverse_proxy 127.0.0.1:8080
      }
      ${config.sops.placeholder."caddy/virtual-host-b"} {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare-api-token"}
        }
        log {
          level INFO
        }
        reverse_proxy 127.0.0.1:8080
      }
      :8080 {
        route /subgen/* {
          uri strip_prefix /subgen
          reverse_proxy ${config.iosmanthus.subgen.address} {
          }
        }

        route /promtail/* {
          uri strip_prefix /promtail
          reverse_proxy https://logs-prod-020.grafana.net {
            header_up Host logs-prod-020.grafana.net
            header_up Authorization "Basic ${config.sops.placeholder."grafana/promtail-basic-auth"}"
          }
        }

        route /prometheus/* {
          uri strip_prefix /prometheus
          reverse_proxy https://prometheus-prod-37-prod-ap-southeast-1.grafana.net {
            header_up Host prometheus-prod-37-prod-ap-southeast-1.grafana.net
            header_up Authorization "Basic ${config.sops.placeholder."grafana/prometheus-basic-auth"}"
          }
        }

        log {
          level ERROR
        }
      }
    '';
  };

}
