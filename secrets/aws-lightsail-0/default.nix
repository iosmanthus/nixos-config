{ ... }: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "cloudflare/api-token" = { };
      "cloudflare/warp/private_key" = { };
      "cloudflare/warp/peer_public_key" = { };
      "cloudflare/warp/local_address_v4" = { };
      "cloudflare/warp/local_address_v6" = { };

      "grafana/promtail-basic-auth" = { };
      "grafana/prometheus-basic-auth" = { };

      "sing-box/shadowtls/username" = { };
      "sing-box/shadowtls/password" = { };
      "sing-box/shadowtls/handshake/server" = { };
      "sing-box/shadowsocks/method" = { };
      "sing-box/shadowsocks/password" = { };
      "sing-box/shadowsocks/users/iosmanthus" = { };
      "sing-box/shadowsocks/users/lego" = { };
      "sing-box/shadowsocks/users/lbwang" = { };
      "sing-box/shadowsocks/users/tover" = { };
      "sing-box/shadowsocks/users/alex" = { };
      "sing-box/shadowsocks/users/mgw" = { };

      "subgen/subscription-url" = { };
      "subgen/personal-port" = { };

      "vaultwarden/env" = { };

      "atuin/db-uri" = { };

      "one-api/sql-dsn" = { };

      "chatgpt-next-web/openai-api-key" = { };
      "chatgpt-next-web/google-api-key" = { };
      "chatgpt-next-web/google-cse-id" = { };
      "chatgpt-next-web/password" = { };
    };
  };
}
