{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.iosmanthus.subgen;
in
{
  options.iosmanthus.subgen = {
    enable = mkEnableOption "subgen";

    package = mkOption {
      type = types.package;
      default = pkgs.subgen;
      description = "The subgen package to use.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1:7878";
    };

    configFile = mkOption {
      type = types.path;
      description = "Path to the Caddy configuration file.";
    };

    exprPath = mkOption {
      type = types.path;
      description = "Path to the expression to evaluate.";
    };

    restartTriggers = mkOption {
      type = with types; listOf unspecified;
      default = [ ];
      description = "List of options that trigger a restart of the service.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.subgen = {
      serviceConfig = {
        Type = "simple";
        StateDirectory = "subgen";
        LogsDirectory = "subgen";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        ExecStart = "${cfg.package}/bin/subgen -config ${cfg.configFile} -expr ${cfg.exprPath} -addr ${cfg.address}";
      };
      inherit (cfg) restartTriggers;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      requires = [ "network-online.target" ];
    };
  };
}
