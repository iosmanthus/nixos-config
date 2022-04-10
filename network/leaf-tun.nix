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
        default = "255.255.255.0";
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
    };
  };

  prerouting = "leaf-tun-pre";

  output = "leaf-tun-out";

  writeScriptBin = name: text: pkgs.writeScriptBin name ''
    #! ${pkgs.runtimeShell} -e
    ${text}
  '';

  writeShScript = name: text: "${writeScriptBin name text}/bin/${name}";

  genIgnoreRule = chain: action: subnet: ''
    -A ${chain} ${action} ${subnet} -j RETURN
  '';

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

  genIgnoreRules = chain: action: subnets:
    foldl'
      (text: net: ''
        ${text}
        ${genIgnoreRule chain action net}
      '') ""
      subnets;

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

    # Ignore private network packets
    ${genIgnoreRules "${prerouting}" "-s" cfg.ignoreSrcAddresses}
    ${genIgnoreRules "${prerouting}" "-d" builtinIgnoreAddresses}
    ${genIgnoreRules "${output}" "-d" builtinIgnoreAddresses}

    # Mark all TCP/UDP packets should route to leaf-tun
    -A ${output} -p udp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${output} -p tcp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${prerouting} -p udp -j MARK --set-mark ${toString cfg.fwmark}
    -A ${prerouting} -p tcp -j MARK --set-mark ${toString cfg.fwmark}

    COMMIT
  '';

  leafConfig = pkgs.writeText "leaf.json" ''
      {
        "inbounds": [
            {
                "tag": "tun",
                "protocol": "tun",
                "settings": {
                    "name": "${cfg.tun.name}",
                    "address": "${cfg.tun.address}",
                    "netmask": "${cfg.tun.netmask}",
                    "gateway": "${cfg.tun.gateway}",
                    "mtu": ${toString cfg.tun.mtu}
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
        Extra address that the leaf-tun service will ignore,
        usually an address of a virtual subnet.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ iptables ];
    networking.firewall.enable = mkForce false;
    systemd.services.leaf-tun = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Enable leaf-tun service";
      path = with pkgs; [ leaf iproute2 iptables ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${leafStart}";
        ExecStartPost = "${leafStartPost}";
        ExecStop = "${leafStop}";
        ExecStopPost = "${leafPostStop}";
      };
    };
  };
}
