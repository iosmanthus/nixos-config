{ config
, ...
}:
{
  imports = [
    ./sing-box.nix
  ];

  disabledModules = [ "services/networking/sing-box.nix" ];

  services.sing-box = {
    enable = true;
    configFile = config.sops.secrets.sing-box.path;
    override = {
      "dns" = {
        "fakeip" = {
          "enabled" = true;
          "inet4_range" = "198.18.0.0/15";
        };
        "rules" = [
          {
            "geosite" = [
              "cn"
            ];
            "server" = "dnspod";
          }
          {
            "outbound" = "any";
            "server" = "dnspod";
          }
          {
            "domain_keyword" = [
              "tidb"
              "pingcap"
            ];
            "server" = "google";
          }
          {
            "query_type" = [
              "A"
              "AAAA"
            ];
            "server" = "remote";
          }
        ];
        "servers" = [
          {
            "address" = "tls://1.1.1.1";
            "detour" = "final";
            "tag" = "google";
          }
          {
            "address" = "119.29.29.29";
            "detour" = "direct";
            "tag" = "dnspod";
          }
          {
            "tag" = "remote";
            "address" = "fakeip";
          }
        ];
        "strategy" = "ipv4_only";
      };
      "route" = {
        "rules" = [
          {
            "outbound" = "dns-out";
            "protocol" = "dns";
          }
          {
            "geosite" = [
              "cn"
            ];
            "outbound" = "direct";
          }
          {
            "geoip" = [
              "cn"
              "private"
            ];
            "outbound" = "direct";
          }
          {
            "domain_keyword" = [
              "ddrk"
              "ddys"
            ];
            "outbound" = "final";
          }
        ];
      };
      "experimental" = {
        "clash_api" = {
          "cache_file" = "cache.db";
          "external_controller" = "127.0.0.1:7990";
          "store_selected" = true;
          "external_ui" = "./ui";
          "external_ui_download_detour" = "final";
        };
      };
      "inbounds" = [
        {
          "tag" = "tun-in";
          "type" = "tun";
          "auto_route" = true;
          "strict_route" = true;
          "inet4_address" = "10.255.0.1/16";
          "interface_name" = "utun0";
          "sniff" = true;
          "stack" = "gvisor";
        }
      ];
      "log" = {
        "level" = "debug";
        "timestamp" = true;
      };
    };
  };
}
