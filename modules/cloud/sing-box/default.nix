{ self
, lib
, config
, ...
}:
with lib;
let
  cfg = config.services.self-hosted.cloud.sing-box;

  ruleBaseUrl = "https://raw.githubusercontent.com/lyc8503/sing-box-rules";

  mkGeositeUrl = geosite: "${ruleBaseUrl}/rule-set-geosite/${geosite}.srs";
  mkGeoipUrl = geoip: "${ruleBaseUrl}/rule-set-geoip/${geoip}.srs";

  warpGeosite = builtins.map
    (geosite: "geosite-${geosite}")
    [
      "category-porn"
      "cloudflare"
      "disney"
      "hbo"
      "hulu"
      "microsoft"
      "netflix"
      "openai"
      "stripe"
      "tiktok"
      "youtube"
    ];

  warpGeoip = builtins.map
    (geoip: "geoip-${geoip}")
    [
      "google"
    ];

  settings = {
    log = {
      level = "debug";
      timestamp = true;
    };
    dns = {
      final = "cloudflare";
      rules = [
        {
          outbound = "any";
          server = "cloudflare";
        }
        {
          inbound = [
            "shadowsocks-multi-user"
          ];
          rule_set = warpGeosite;
          server = "warp";
        }
      ];
      servers = [
        {
          tag = "cloudflare";
          address = "tls://1.1.1.1";
          detour = "direct";
          strategy = "prefer_ipv6";
        }
        {
          tag = "warp";
          address = "tls://1.1.1.1";
          detour = "warp";
          strategy = "prefer_ipv6";
        }
      ];
    };
    route = {
      final = "direct";
      rule_set = builtins.map
        (geosite: {
          type = "remote";
          tag = geosite;
          format = "binary";
          url = mkGeositeUrl geosite;
          download_detour = "direct";
        })
        warpGeosite ++ builtins.map
        (
          geoip: {
            type = "remote";
            tag = geoip;
            format = "binary";
            url = mkGeoipUrl geoip;
            download_detour = "direct";
          }
        )
        warpGeoip;
      rules = [
        {
          rule_set = warpGeoip ++ warpGeosite;
          outbound = "warp";
        }
      ];
    };
    inbounds = [
      {
        type = "shadowtls";
        listen = "::";
        listen_port = cfg.ingress;
        version = 3;
        strict_mode = true;
        domain_strategy = "prefer_ipv6";
        sniff = true;
        sniff_override_destination = true;
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
        tag = "warp";
        server = "engage.cloudflareclient.com";
        server_port = 2408;
        mtu = 1330;
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
in
{
  imports = [
    self.nixosModules.sing-box
  ];

  options.services.self-hosted.cloud.sing-box = {
    enable = mkEnableOption "sing-box service in the cloud";
    ingress = mkOption {
      type = types.int;
      description = "The port to listen on for incoming connections";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.ingress ];

    services.self-hosted.sing-box = {
      enable = true;
      configFile = config.sops.templates."sing-box.json".path;
    };

    systemd.services.sing-box.restartTriggers = [
      config.sops.templates."sing-box.json".content
    ];

    sops.templates."sing-box.json" = {
      content = builtins.toJSON settings;
    };
  };
}
