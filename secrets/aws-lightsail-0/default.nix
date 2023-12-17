{ ... }: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "cloudflare-api-token" = { };
      "aws-lightsail-0-ip" = { };

      "caddy/virtual-host-a" = { };
      "caddy/virtual-host-b" = { };

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
    };
  };
}
