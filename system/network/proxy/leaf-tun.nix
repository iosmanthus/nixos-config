{ config
, pkgs
, lib
, ...
}:
with lib;

let
  cfg = config.services.leaf-tun;

  proxyOptions = {
    options = {
      type = mkOption {
        description = "Proxy type";
        type = types.str;
      };
      address = mkOption {
        description = "Proxy address";
        type = types.str;
      };
      port = mkOption {
        description = "Proxy port";
        type = types.ints.u16;
      };
    };
  };

  tunOptions = {
    options = {
      name = mkOption {
        type = types.str;
        default = "utun8";
        description = "The tun device name for leaf";
      };

      address = mkOption {
        type = types.str;
        default = "10.10.0.2";
        description = "The tun device address";
      };

      netmask = mkOption {
        type = types.str;
        default = "255.255.0.0";
        description = "The tun device netmask";
      };

      gateway = mkOption {
        type = types.str;
        default = "10.10.0.1";
        description = "The tun device gateway address";
      };

      mtu = mkOption {
        type = types.int;
        default = 1500;
        description = "The tun device MTU";
      };

      fakeDnsExclude = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra domains that the leaf-tun service will return the real IP address.
        '';
      };
    };
  };

  prerouting = "leaf-tun-pre";

  output = "leaf-tun-out";

  writeScriptBin = name: text: pkgs.writeScriptBin name ''
    #! ${pkgs.runtimeShell} -e
    ${text}
  '';

  writeShScript = name: text: "${writeScriptBin name text}/bin/${name}";

  builtinIgnoreAddresses = [
    "0.0.0.0/8"
    "10.0.0.0/8"
    "127.0.0.0/8"
    "169.254.0.0/16"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "224.0.0.0/4"
    "240.0.0.0/4"
  ];

  mkIgnoreRule = chain: action: subnet: ''
    -A ${chain} ${action} ${subnet} -j RETURN
  '';

  mkIgnoreRules = chain: action: foldl'
    (text: net: ''
      ${text}
      ${mkIgnoreRule chain action net}
    '') "";

  iptablesRules = pkgs.writeText "leaf-tun-iptables.rules" ''
    *mangle
    :${output} - [0:0]
    :${prerouting} - [0:0]

    -A PREROUTING -j ${prerouting}
    -A OUTPUT -j ${output}

    # Ignore marked packets
    ${optionalString (cfg.ignoreMark != null) ''
      -A ${output} -m mark --mark ${toString cfg.ignoreMark} -j RETURN
    ''}

    # Ignore self packets
    -A ${output} -m owner --uid-owner ${cfg.user} -j RETURN

    # Ignore private network packets
    ${mkIgnoreRules "${prerouting}" "-s" cfg.ignoreSrcAddresses}
    ${mkIgnoreRules "${prerouting}" "-d" builtinIgnoreAddresses}
    ${mkIgnoreRules "${output}" "-d" builtinIgnoreAddresses}

    # Mark all TCP/UDP packets should route to leaf-tun
    -A ${output} -p udp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${output} -p tcp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${prerouting} -p udp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${prerouting} -p tcp -j MARK --set-mark ${toString cfg.fwmark}

    COMMIT
  '';

  geoVersion = "202206152213";

  geosite = builtins.fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${geoVersion}/geosite.dat";
    sha256 = "0ri52fihvjw9n76gi5nns37bqndnch23a2l0h67f0lpy1kw5kdpz";
  };

  leafConfig = pkgs.writeText "leaf.json" ''
      {
        "dns": {
            "servers": [
                "119.29.29.29"
            ]
        },
        "router": {
            "rules": [
                {
                    "domainSuffix": [ "pingcap.net" ],
                    "target": "direct"
                },
                {
                    "external": [
                        "site:${geosite}:geolocation-!cn"
                    ],
                    "target": "proxy"
                },
                {
                    "external": [
                        "site:${geosite}:tld-cn",
                        "site:${geosite}:cn"
                    ],
                    "target": "direct"
                },
                {
                    "external": [
                        "mmdb:${pkgs.mmdb}:cn"
                    ],
                    "target": "direct"
                },
                {
                    "inboundTag": [
                        "tun"
                    ],
                    "target": "proxy"
                }
            ]
        },
        "inbounds": [
            {
                "tag": "tun",
                "protocol": "tun",
                "settings": {
                    "name": "${cfg.tun.name}",
                    "address": "${cfg.tun.address}",
                    "netmask": "${cfg.tun.netmask}",
                    "gateway": "${cfg.tun.gateway}",
                    "mtu": ${toString cfg.tun.mtu},
                    "fakeDnsExclude": ${builtins.toJSON cfg.tun.fakeDnsExclude}
                }
            }
        ],
        "outbounds": [
            {
                "tag": "proxy",
                "protocol": "${cfg.proxy.type}",
                "settings": {
                    "address": "${cfg.proxy.address}",
                    "port": ${toString cfg.proxy.port}
                }
            },
            {
                "tag": "direct",
                "protocol": "direct"
            }
        ]
    }
  '';

  leafStart = writeShScript "leaf-start" ''
    leaf -c ${leafConfig}
  '';

  leafStartPost = writeShScript "leaf-start-post" ''
    while [ ! -d /sys/class/net/${cfg.tun.name} ]; do
      sleep 1;
    done
    ip route replace default dev ${cfg.tun.name} table ${toString cfg.rtTable}
    ip rule add fwmark ${toString cfg.fwmark} table ${toString cfg.rtTable}
    iptables-restore ${iptablesRules} -w --noflush
  '';

  cleanIptables = writeShScript "iptables-clean" ''
    iptables -t mangle -w -D PREROUTING -j ${prerouting}
    iptables -t mangle -w -D OUTPUT -j ${output}

    iptables -t mangle -w -F ${prerouting}
    iptables -t mangle -w -F ${output}

    iptables -t mangle -w -X ${prerouting}
    iptables -t mangle -w -X ${output}
  '';

  leafStop = writeShScript "leaf-stop" ''
    ${cleanIptables}
    ip rule delete table ${toString cfg.rtTable}
  '';

  leafPostStop = writeShScript "leaf-post-stop" ''
    ${leafStop} > /dev/null 2>&1
  '';
in
{
  options.services.leaf-tun = {
    enable = mkEnableOption "Enable leaf-tun service";

    tun = mkOption {
      default = { };
      type = types.submodule tunOptions;
    };


    proxy = mkOption {
      type = types.submodule proxyOptions;
    };

    user = mkOption {
      type = types.str;
      default = "leaf";
      description = "The system user for leaf-tun service";
    };

    fwmark = mkOption {
      type = types.ints.u8;
      default = 255;
      description = "The firewall mark for the packet need to be proxied";
    };

    ignoreMark = mkOption {
      type = types.nullOr types.ints.u8;
      default = null;
      description = "The firewall mark for the packet need not to be proxied";
    };

    rtTable = mkOption {
      type = types.int;
      default = 1080;
      description = "The route table for the leaf-tun device";
    };

    ignoreSrcAddresses = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra addresses that the leaf-tun service will ignore,
        usually the addresses of virtual subnets.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ iptables ];

    users.users = {
      leaf = {
        isSystemUser = true;
        group = cfg.user;
      };
    };
    users.groups.${cfg.user} = { };

    networking.firewall.enable = mkForce false;

    systemd.services.leaf-tun = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Enable leaf-tun service";
      path = with pkgs; [ leaf iproute2 iptables ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.user;
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
        ExecStart = "${leafStart}";
        ExecStartPost = "${leafStartPost}";
        ExecStop = "${leafStop}";
        ExecStopPost = "${leafPostStop}";
      };
    };
  };
}
