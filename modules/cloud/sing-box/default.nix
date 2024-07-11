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

  warpGeosite = builtins.map
    (geosite: "geosite-${geosite}")
    [
      "category-porn"
      "cloudflare"
      "disney"
      "hbo"
      "hulu"
      "netflix"
      "openai"
      "stripe"
      "tiktok"
      "microsoft"
      # "youtube"
    ];

  tcpInboud = {
    type = "vless";
    listen = "::";
    listen_port = cfg.ingress;
    sniff = true;
    sniff_override_destination = true;
    tcp_fast_open = true;
    users = config.sops.placeholder."sing-box/vless/users";
    tls =
      let
        server_name = config.sops.placeholder."sing-box/vless/reality/server-name";
        private_key = config.sops.placeholder."sing-box/vless/reality/private-key";
        short_id = [ config.sops.placeholder."sing-box/vless/reality/short-id" ];
      in
      {
        enabled = true;
        inherit server_name;
        reality = {
          inherit private_key short_id;
          enabled = true;
          handshake = {
            server = server_name;
            server_port = 443;
          };
        };
      };
  };

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
        warpGeosite;
      rules = [
        {
          protocol = "bittorrent";
          outbound = "block";
        }
        {
          rule_set = warpGeosite;
          outbound = "warp";
        }
      ];
    };

    inbounds = [ tcpInboud ];
    outbounds = [
      {
        type = "direct";
        tag = "direct";
      }
      {
        type = "block";
        tag = "block";
      }
      {
        type = "wireguard";
        tag = "warp";
        server = "engage.cloudflareclient.com";
        server_port = 2408;
        mtu = 1330;
        peer_public_key = config.sops.placeholder."cloudflare/warp/peer_public_key";
        local_address = [
          config.sops.placeholder."cloudflare/warp/local_address_v4"
          config.sops.placeholder."cloudflare/warp/local_address_v6"
        ];
        private_key = config.sops.placeholder."cloudflare/warp/private_key";
      }
    ];
  };

  # nested JSON objects should be unquoted
  settingsJSON = builtins.replaceStrings
    [ ''"${config.sops.placeholder."sing-box/vless/users"}"'' ]
    [ config.sops.placeholder."sing-box/vless/users" ]
    (builtins.toJSON settings);
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

      ../../../secrets/cloud/sing-box/secrets.json
    ];

    sops.templates."sing-box.json" = {
      content = settingsJSON;
    };
  };
}
