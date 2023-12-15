{ config, ... }: {
  sops.secrets = {
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
  };

  sops.templates."sing-box.json".content = builtins.toJSON {
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
}
