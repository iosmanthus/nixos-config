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
      www.iosmanthus.com {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        reverse_proxy 127.0.0.1:8080
      }
      vault.iosmanthus.com {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        header / {
        	-Last-Modified
        	-Server
        	-X-Powered-By
        	Strict-Transport-Security "max-age=31536000;"
        	X-Content-Type-Options "nosniff"
        	X-Frame-Options "DENY"
        	X-Robots-Tag "noindex, nofollow"
        	X-XSS-Protection "0"
        }
        reverse_proxy ${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        }
      }
      atuin.iosmanthus.com {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        header / {
        	-Last-Modified
        	-Server
        	-X-Powered-By
        	Strict-Transport-Security "max-age=31536000;"
        	X-Content-Type-Options "nosniff"
        	X-Frame-Options "DENY"
        	X-Robots-Tag "noindex, nofollow"
        	X-XSS-Protection "0"
        }
        reverse_proxy 127.0.0.1:8888 {
          header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        }
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
