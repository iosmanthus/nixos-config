{ config
, lib
, ...
}:
let
  mkReverseProxy =
    { backend
    , logLevel
    , basicauth ? null
    }: {
      extraConfig = ''
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        }
        log {
          level ${logLevel}
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
        reverse_proxy ${backend} {
          header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        }
        ${lib.optionalString (basicauth != null) ''
          basicauth {
            ${basicauth.username} ${basicauth.hashedPassword}
          }
        ''}
      '';
    };
in
{
  networking.firewall.allowedTCPPorts = [ 443 ];

  sops.templates."caddy.env" = {
    content = ''
      CLOUDFLARE_API_TOKEN=${config.sops.placeholder."cloudflare/api-token"}
    '';
  };

  systemd.services.caddy = {
    restartTriggers = [
      config.sops.templates."caddy.env".content
    ];
    serviceConfig = {
      EnvironmentFile = [ config.sops.templates."caddy.env".path ];
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "subgen.iosmanthus.com" = mkReverseProxy {
        backend = config.services.self-hosted.subgen.address;
        logLevel = "INFO";
      };
      "vault.iosmanthus.com" = mkReverseProxy {
        backend = "${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        logLevel = "INFO";
      };
      "atuin.iosmanthus.com" = mkReverseProxy {
        backend = "127.0.0.1:8888";
        logLevel = "INFO";
      };
      "chatgpt.iosmanthus.com" = mkReverseProxy {
        backend = "127.0.0.1:3210";
        logLevel = "INFO";
      };
      "o2g.iosmanthus.com" = mkReverseProxy {
        backend = "127.0.0.1:${toString config.services.self-hosted.gemini-openai-proxy.port}";
        logLevel = "INFO";
      };
    };
  };
}
