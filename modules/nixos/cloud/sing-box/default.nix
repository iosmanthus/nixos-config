{
  self,
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.self-hosted.cloud.sing-box;

  ports = {
    shadowtls = 18443;
    shadowsocks = 18080;
  };

  ruleBaseUrl = "https://raw.githubusercontent.com/lyc8503/sing-box-rules";

  mkGeositeUrl = geosite: "${ruleBaseUrl}/rule-set-geosite/${geosite}.srs";

  defaultUnlockSites = builtins.map (geosite: "geosite-${geosite}") [
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

  defaultUnlockServer = {
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
  };

  unlockSettings =
    if cfg.unlockSettings == null then
      {
        server = defaultUnlockServer;
        sites = defaultUnlockSites;
      }
    else
      cfg.unlockSettings;

  shadowtls = {
    detour = "shadowsocks-multi-users";

    listen = "::";
    listen_port = ports.shadowtls;
    sniff = true;
    sniff_override_destination = true;
    tcp_fast_open = true;

    type = "shadowtls";
    version = 3;
    strict_mode = true;
    users = [
      {
        name = config.sops.placeholder."sing-box/shadowtls/username";
        password = config.sops.placeholder."sing-box/shadowtls/password";
      }
    ];
    handshake = {
      server = config.sops.placeholder."sing-box/shadowtls/server-name";
      server_port = 443;
    };
  };

  shadowsocks = {
    listen = "::";
    listen_port = ports.shadowsocks;
    sniff = true;
    sniff_override_destination = true;
    tcp_fast_open = true;

    type = "shadowsocks";
    tag = "shadowsocks-multi-users";
    method = config.sops.placeholder."sing-box/shadowsocks/method";
    password = config.sops.placeholder."sing-box/shadowsocks/server-password";
    users = config.sops.placeholder."sing-box/shadowsocks/users";
    multiplex = {
      enabled = true;
      padding = true;
    };
  };

  settings = {
    log = {
      level = "debug";
      timestamp = true;
      user_idx = true;
      parent_id = true;
    };
    dns = {
      final = "cloudflare";
      rules = [
        {
          outbound = "any";
          server = "cloudflare";
        }
        {
          rule_set = unlockSettings.sites;
          server = unlockSettings.server.tag;
        }
      ];
      servers = [
        {
          tag = "cloudflare";
          address = "tls://1.1.1.1";
          detour = "direct";
          strategy = "prefer_ipv6";
        }
        rec {
          inherit (unlockSettings.server) tag;
          detour = tag;
          address = "tls://1.1.1.1";
          strategy = "prefer_ipv6";
        }
      ];
    };
    route = {
      final = "direct";
      rule_set = builtins.map (geosite: {
        type = "remote";
        tag = geosite;
        format = "binary";
        url = mkGeositeUrl geosite;
        download_detour = "direct";
      }) unlockSettings.sites;
      rules = [
        {
          protocol = "bittorrent";
          outbound = "block";
        }
        {
          rule_set = unlockSettings.sites;
          outbound = unlockSettings.server.tag;
        }
      ];
    };

    inbounds = [
      shadowtls
      shadowsocks
    ];
    outbounds = [
      {
        type = "direct";
        tag = "direct";
      }
      {
        type = "block";
        tag = "block";
      }
      unlockSettings.server
    ];
  };

  # nested JSON objects should be unquoted
  settingsJSON = builtins.replaceStrings [
    ''"${config.sops.placeholder."sing-box/shadowsocks/users"}"''
  ] [ config.sops.placeholder."sing-box/shadowsocks/users" ] (builtins.toJSON settings);

  unlockSettingsOpts =
    { ... }:
    {
      options = {
        server = mkOption {
          inherit (pkgs.formats.json { }) type;
          description = "The unlock server";
        };
        sites = mkOption {
          type = types.listOf types.str;
          description = "The sites to unlock";
        };
      };
    };
in
{
  imports = [ self.nixosModules.sing-box ];

  options.services.self-hosted.cloud.sing-box = {
    enable = mkEnableOption "sing-box service in the cloud";
    unlockSettings = mkOption {
      type = types.nullOr (types.submodule unlockSettingsOpts);
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      ports.shadowsocks
      ports.shadowtls
    ];

    services.self-hosted.sing-box = {
      enable = true;
      configFile = config.sops.templates."sing-box.json".path;
    };

    systemd.services.sing-box.restartTriggers = [
      config.sops.templates."sing-box.json".content

      ../../../../secrets/cloud/sing-box/secrets.json
    ];

    sops.templates."sing-box.json" = {
      content = settingsJSON;
    };
  };
}
