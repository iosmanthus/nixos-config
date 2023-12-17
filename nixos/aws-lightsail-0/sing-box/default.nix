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
          listen = "::";
          listen_port = 0;
          method = config.sops.placeholder."sing-box/shadowsocks/method";
          password = config.sops.placeholder."sing-box/shadowsocks/password";
          users = [
            {
              name = "iosmanthus";
              password = config.sops.placeholder."sing-box/shadowsocks/users/iosmanthus";
            }
            {
              name = "lego";
              password = config.sops.placeholder."sing-box/shadowsocks/users/lego";
            }
            {
              name = "lbwang";
              password = config.sops.placeholder."sing-box/shadowsocks/users/lbwang";
            }
            {
              name = "tover";
              password = config.sops.placeholder."sing-box/shadowsocks/users/tover";
            }
            {
              name = "alex";
              password = config.sops.placeholder."sing-box/shadowsocks/users/alex";
            }
            {
              name = "mgw";
              password = config.sops.placeholder."sing-box/shadowsocks/users/mgw";
            }
          ];
        }
      ];
      outbounds = [
        {
          type = "direct";
          domain_strategy = "prefer_ipv6";
        }
      ];
    };
  };
}
