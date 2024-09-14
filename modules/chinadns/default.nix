{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.self-hosted.chinadns;
  writeShScript =
    name: text:
    let
      dir = pkgs.writeScriptBin name ''
        #! ${pkgs.runtimeShell} -e
        ${text}
      '';
    in
    "${dir}/bin/${name}";

  startScript = writeShScript "chinadns-start" ''
    ${pkgs.chinadns}/bin/chinadns \
      -addr ${cfg.address}:${toString cfg.port} \
      -status-addr ${cfg.statusAddress} \
      -geoip-cn ${cfg.geoipCN} \
      -geosite-cn ${cfg.geositeCN} \
      -geosite-not-cn ${cfg.geositeNotCN} \
      -state ${cfg.statePath}
  '';
in
{
  options = {
    services.self-hosted.chinadns = {
      enable = mkEnableOption "chinadns server";
      address = mkOption {
        type = types.str;
        default = "0.0.0.0";
      };
      port = mkOption {
        type = types.int;
        default = 10853;
      };
      statusAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:10888";
      };
      geoipCN = mkOption { type = types.path; };
      geositeCN = mkOption { type = types.path; };
      geositeNotCN = mkOption { type = types.path; };
      statePath = mkOption {
        type = types.path;
        default = "/var/lib/chinadns/data";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ cfg.port ];
    systemd.services.chinadns = {
      description = "chinadns server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${startScript}";
        RuntimeDirectory = "chinadns";
        StateDirectory = "chinadns";
        RuntimeDirectoryMode = "0700";
        DynamicUser = true;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          # Required for connecting to database sockets,
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
