{ config
, ...
}:
{
  iosmanthus.sing-box = {
    enable = true;
    configFile = config.sops.templates."sing-box.json".path;
  };

  networking.firewall.allowedTCPPorts = [ 10080 ];

  systemd.services.sing-box.restartTriggers = [
    config.sops.templates."sing-box.json".content
  ];

  sops.templates."sing-box.json" = {
    content = builtins.toJSON {
      log = {
        level = "debug";
        timestamp = true;
      };
      dns = {
        final = "cloudflare";
        servers = [
          {
            tag = "cloudflare";
            address = "tls://1.1.1.1";
            detour = "direct";
            strategy = "prefer_ipv6";
          }
        ];
      };
      route = {
        final = "direct";
        rules = [
          {
            inbound = [
              "shadowsocks-multi-user"
            ];
            auth_user = [
              "iosmanthus"
              "lego"
              "lbwang"
            ];
            outbound = "warp+";
          }
        ];
      };
      inbounds = [
        {
          type = "shadowtls";
          listen = "::";
          listen_port = 10080;
          version = 3;
          strict_mode = true;
          users = [
            {
              name = config.sops.placeholder."sing-box/shadowtls/username";
              password = config.sops.placeholder."sing-box/shadowtls/password";
            }
          ];
          handshake = {
            server = config.sops.placeholder."sing-box/shadowtls/handshake/server";
            server_port = 443;
          };
          tcp_fast_open = true;
          detour = "shadowsocks-multi-user";
        }
        {
          type = "shadowsocks";
          tag = "shadowsocks-multi-user";
          listen = "::1";
          listen_port = 0;
          method = config.sops.placeholder."sing-box/shadowsocks/method";
          password = config.sops.placeholder."sing-box/shadowsocks/password";
          users = builtins.map
            (user: {
              name = user;
              password = config.sops.placeholder."sing-box/shadowsocks/users/${user}";
            }) [
            "iosmanthus"
            "lego"
            "lbwang"
            "tover"
            "alex"
            "mgw"
          ];
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
        {
          type = "wireguard";
          tag = "warp+";

          server = "engage.cloudflareclient.com";
          mtu = 1280;
          server_port = 2408;
          system_interface = true;
          interface_name = "wg0";
          peer_public_key = config.sops.placeholder."cloudflare/warp/peer_public_key";
          local_address = [
            config.sops.placeholder."cloudflare/warp/local_address_v4"
            config.sops.placeholder."cloudflare/warp/local_address_v6"
          ];
          private_key = config.sops.placeholder."cloudflare/warp/private_key";
        }
      ];
    };
  };
}
