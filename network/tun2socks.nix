{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.services.tun2socks;
in
with lib;
{
  options.services.tun2socks = {
    enable = mkEnableOption "Enable tun2socks service";

    tcp = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable proxy service for TCP";
        };
      };
      default = {
        enable = true;
      };
      description = "TCP settings";
    };

    udp = mkOption {
      default = {
        enable = true;
        udpTimeout = 60;
      };
      type = types.submodule
        {
          options = {
            enable = mkEnableOption "Enable proxy service for UDP";
            udpTimeout = mkOption {
              description = "UDP session timeout";
              type = types.int;
            };
          };
        };
      description = "UDP settings";
    };

    icmp = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable echo service for ICMP";
        };
      };
      default = {
        enable = false;
      };
      description = "ICMP settings";
    };

    proxy = mkOption {
      type = types.submodule {
        options = {
          type = mkOption {
            description = "Proxy type";
            type = types.str;
          };
          address = mkOption {
            description = "Proxy address";
            type = types.str;
          };
        };
      };
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

    tunName = mkOption {
      type = types.str;
      default = "utun";
      description = "The tun device name for tun2socks";
    };

    gateway = mkOption {
      type = types.str;
      default = "10.255.0.1/24";
      description = "The tun device gateway address";
    };

    rtTable = mkOption {
      type = types.int;
      default = 1000;
      description = "The route table for the tun2socks device";
    };

    ignoreSrcAddresses = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra address that the tun2socks service will ignore,
        usually an address of a virtual subnet.
      '';
    };
  };

  config =
    let
      writeShScript = name: text:
        let
          dir = pkgs.writeScriptBin name ''
            #! ${pkgs.runtimeShell} -e
            ${text}
          '';
        in
        "${dir}/bin/${name}";

      iptablesRules = pkgs.writeText "tun2socks-iptables.rules" ''
                *mangle
                :tun2socks-out - [0:0]
                :tun2socks-pre - [0:0]
                -A PREROUTING -j tun2socks-pre
                -A OUTPUT -j tun2socks-out
                ${optionalString (cfg.ignoreMark != null) "-A tun2socks-out -m mark --mark ${toString cfg.ignoreMark} -j RETURN"}
                -A tun2socks-out -d 0.0.0.0/8 -j RETURN
                -A tun2socks-out -d 10.0.0.0/8 -j RETURN
                -A tun2socks-out -d 127.0.0.0/8 -j RETURN
                -A tun2socks-out -d 169.254.0.0/16 -j RETURN
                -A tun2socks-out -d 172.16.0.0/12 -j RETURN
                -A tun2socks-out -d 192.168.0.0/16 -j RETURN
                -A tun2socks-out -d 224.0.0.0/4 -j RETURN
                -A tun2socks-out -d 240.0.0.0/4 -j RETURN
                ${optionalString cfg.udp.enable "-A tun2socks-out -p udp -j MARK --set-mark ${toString cfg.fwmark}"}
                ${optionalString cfg.tcp.enable "-A tun2socks-out -p tcp -j MARK --set-mark ${toString cfg.fwmark}"}
                ${optionalString cfg.icmp.enable "-A tun2socks-out -p icmp -j MARK --set-mark ${toString cfg.fwmark}"}

                ${foldl'
        (rules: addr: "${rules}\n-A tun2socks-pre -s ${addr} -j RETURN")
        ""
        cfg.ignoreSrcAddresses}
                -A tun2socks-pre -d 0.0.0.0/8 -j RETURN
                -A tun2socks-pre -d 10.0.0.0/8 -j RETURN
                -A tun2socks-pre -d 127.0.0.0/8 -j RETURN
                -A tun2socks-pre -d 169.254.0.0/16 -j RETURN
                -A tun2socks-pre -d 172.16.0.0/12 -j RETURN
                -A tun2socks-pre -d 192.168.0.0/16 -j RETURN
                -A tun2socks-pre -d 224.0.0.0/4 -j RETURN
                -A tun2socks-pre -d 240.0.0.0/4 -j RETURN
                ${optionalString cfg.udp.enable "-A tun2socks-pre -p udp -j MARK --set-mark ${toString cfg.fwmark}"}
                ${optionalString cfg.tcp.enable "-A tun2socks-pre -p tcp -j MARK --set-mark ${toString cfg.fwmark}"}
                ${optionalString cfg.icmp.enable  "-A tun2socks-pre -p icmp -j MARK --set-mark ${toString cfg.fwmark}"}
                COMMIT
      '';

      cleanIptables = ''
        iptables -t mangle -w -D PREROUTING -j tun2socks-pre
        iptables -t mangle -w -D OUTPUT -j tun2socks-out

        iptables -t mangle -w -F tun2socks-pre
        iptables -t mangle -w -F tun2socks-out

        iptables -t mangle -w -X tun2socks-pre
        iptables -t mangle -w -X tun2socks-out
      '';

      udpTimeoutOption = optionalString (cfg.udp.enable) "-udp-timeout ${toString cfg.udp.udpTimeout}";
      startTun2socks = ''
        tun2socks -loglevel warn -device ${cfg.tunName} -proxy ${cfg.proxy.type}://${cfg.proxy.address} ${udpTimeoutOption}
      '';
      tun2socksStart = writeShScript "tun2socks-start" ''
        ${startTun2socks}
      '';

      setupTun = ''
        while [ ! -d /sys/class/net/${cfg.tunName} ]; do sleep 1; done
        ip link set ${cfg.tunName} up
        ip addr replace ${cfg.gateway} dev ${cfg.tunName}
      '';

      tun2socksStartPost = writeShScript "tun2socks-start-post" ''
        ${setupTun}
        ip route replace default dev ${cfg.tunName} table ${toString cfg.rtTable}
        ip rule add fwmark ${toString cfg.fwmark} table ${toString cfg.rtTable}
        iptables-restore ${iptablesRules} -w
      '';

      tun2socksStop = writeShScript "tun2socks-stop" ''
        ${cleanIptables}
        ip rule delete table ${toString cfg.rtTable}
      '';

      tun2socksStopPost = writeShScript "tun2socks-stop-post" ''
        ip rule delete table ${toString cfg.rtTable} > /dev/null 2>&1
      '';
    in
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ iptables ];
      networking.firewall.enable = mkForce false;
      systemd.services.tun2socks =
        {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          description = "Enable tun2socks service";
          path = with pkgs; [ tun2socks iproute2 iptables ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${tun2socksStart}";
            ExecStartPost = "${tun2socksStartPost}";
            ExecStop = "${tun2socksStop}";
            ExecStopPost = "${tun2socksStopPost}";
          };
        };
    };
}
