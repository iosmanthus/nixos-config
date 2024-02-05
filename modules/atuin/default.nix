{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types mdDoc mkIf;
  cfg = config.iosmanthus.atuin;
in
{
  options = {
    iosmanthus.atuin = {
      enable = lib.mkEnableOption (mdDoc "Atuin server for shell history sync");

      environmentFile = mkOption {
        type = types.path;
        description = "Path to a file containing environment variables to be loaded by the atuin service";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.atuin = {
      description = "atuin server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.atuin}/bin/atuin server start";
        RuntimeDirectory = "atuin";
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

        EnvironmentFile = cfg.environmentFile;
      };

      environment = {
        ATUIN_CONFIG_DIR = "/run/atuin"; # required to start, but not used as configuration is via environment variables
      };
    };
  };
}
