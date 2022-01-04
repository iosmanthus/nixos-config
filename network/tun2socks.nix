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
      enable = mkEnableOption "tun2socks service";

      tcp = mkOption {
        type = types.bool;
        default = true;
        description = "If proxy the TCP connection";
      };

      udp = mkOption {
        default = {
          udpTimeout = 15;
        };
        type = types.nullOr (
          types.submodule {
            options = {
              udpTimeout = mkOption {
                description = "UDP session timeout";
                type = types.int;
              };
            };
          }
        );
      };

      icmp = mkOption {
        type = types.bool;
        default = false;
        description = "If proxy the ICMP packet";
      };

      socksProxy = mkOption {
        type = types.str;
        example = "127.0.0.1:1080";
        description = "The SOCK5 proxy for tproxy service";
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
        default = [];
        description = ''
          Extra address that the tun2socks service will ignore,
          usually an address of a virtual subnet.
        '';
      };
    };

    config =
      let
        writeShScript = name: text: let
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
          ${optionalString (cfg.udp != null) "-A tun2socks-out -p udp -j MARK --set-mark ${toString cfg.fwmark}"}
          ${optionalString cfg.tcp "-A tun2socks-out -p tcp -j MARK --set-mark ${toString cfg.fwmark}"}
          ${optionalString cfg.icmp "-A tun2socks-out -p icmp -j MARK --set-mark ${toString cfg.fwmark}"}

          ${foldl'
          (rules: addr: "${rules}\n-A tun2socks-pre -s ${addr} -j RETURN")
          ""
          cfg.ignoreSrcAddresses}
          ${optionalString (cfg.ignoreMark != null) "-A tun2socks-pre -m mark --mark ${toString cfg.ignoreMark} -j RETURN"}
          -A tun2socks-pre -d 0.0.0.0/8 -j RETURN
          -A tun2socks-pre -d 10.0.0.0/8 -j RETURN
          -A tun2socks-pre -d 127.0.0.0/8 -j RETURN
          -A tun2socks-pre -d 169.254.0.0/16 -j RETURN
          -A tun2socks-pre -d 172.16.0.0/12 -j RETURN
          -A tun2socks-pre -d 192.168.0.0/16 -j RETURN
          -A tun2socks-pre -d 224.0.0.0/4 -j RETURN
          -A tun2socks-pre -d 240.0.0.0/4 -j RETURN
          ${optionalString (cfg.udp != null) "-A tun2socks-pre -p udp -j MARK --set-mark ${toString cfg.fwmark}"}
          ${optionalString cfg.tcp "-A tun2socks-pre -p tcp -j MARK --set-mark ${toString cfg.fwmark}"}
          ${optionalString cfg.icmp "-A tun2socks-pre -p icmp -j MARK --set-mark ${toString cfg.fwmark}"}
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

        udpTimeout = optionalString (cfg.udp != null) "-udp-timeout ${toString cfg.udp.udpTimeout}";
        tun2socksStart = writeShScript "tun2socks-start" ''
          tun2socks -loglevel warn -device ${cfg.tunName} -proxy ${cfg.socksProxy} ${udpTimeout}
        '';

        tun2socksStartPost = writeShScript "tun2socks-start-post" ''
          while [ ! -d /sys/class/net/${cfg.tunName} ]; do sleep 1; done
          ip link set ${cfg.tunName} up
          ip addr replace ${cfg.gateway} dev ${cfg.tunName}
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
