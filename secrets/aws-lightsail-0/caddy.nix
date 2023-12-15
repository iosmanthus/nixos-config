{ config
, ...
}: {
  sops.secrets = {
    "caddy/cloudflare-api-token" = { };
    "caddy/virtual-host-a" = { };
    "caddy/virtual-host-b" = { };
  };

  sops.templates."Caddyfile" = {
    content = ''
      ${config.sops.placeholder."caddy/virtual-host-a"} {
        tls {
          dns cloudflare ${config.sops.placeholder."caddy/cloudflare-api-token"}
        }
        reverse_proxy 127.0.0.1:8080
      }
      ${config.sops.placeholder."caddy/virtual-host-b"} {
        tls {
          dns cloudflare ${config.sops.placeholder."caddy/cloudflare-api-token"}
        }
        reverse_proxy 127.0.0.1:8080
      }
      :8080 {
        route /subgen/* {
          uri strip_prefix /subgen
          reverse_proxy ${config.iosmanthus.subgen.address} {
          }
        }
        log {
          level DEBUG
        }
      }
    '';
  };
}
