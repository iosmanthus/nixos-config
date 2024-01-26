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
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        reverse_proxy 127.0.0.1:8080
      }
      ${config.sops.placeholder."caddy/virtual-host-b"} {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        reverse_proxy 127.0.0.1:8080
      }
      ${config.sops.placeholder."caddy/virtual-host-c"} {
        tls {
          dns cloudflare ${config.sops.placeholder."cloudflare/api-token"}
        }
        log {
          level INFO
        }
        # Uncomment to improve security (WARNING: only use if you understand the implications!)
        # If you want to use FIDO2 WebAuthn, set X-Frame-Options to "SAMEORIGIN" or the Browser will block those requests
        header / {
        	# Enable HTTP Strict Transport Security (HSTS)
        	Strict-Transport-Security "max-age=31536000;"
        	# Disable cross-site filter (XSS)
        	X-XSS-Protection "0"
        	# Disallow the site to be rendered within a frame (clickjacking protection)
        	X-Frame-Options "DENY"
        	# Prevent search engines from indexing (optional)
        	X-Robots-Tag "noindex, nofollow"
        	# Disallow sniffing of X-Content-Type-Options
        	X-Content-Type-Options "nosniff"
        	# Server name removing
        	-Server
        	# Remove X-Powered-By though this shouldn't be an issue, better opsec to remove
        	-X-Powered-By
        	# Remove Last-Modified because etag is the same and is as effective
        	-Last-Modified
        }
        reverse_proxy ${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
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
