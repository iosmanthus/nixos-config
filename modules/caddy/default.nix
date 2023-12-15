{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.iosmanthus.caddy;
in
{
  options.iosmanthus.caddy = {
    enable = mkEnableOption "caddy";

    package = mkOption {
      type = types.package;
      default = pkgs.caddy;
      description = "The Caddy package to use.";
    };

    configFile = mkOption {
      type = types.path;
      description = "Path to the Caddy configuration file.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.iosmanthus-caddy = {
      serviceConfig = {
        Type = "simple";
        StateDirectory = "caddy";
        LogsDirectory = "caddy";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        Environment = [ "XDG_DATA_HOME=%S" ];
        ExecStart = "${cfg.package}/bin/caddy run --watch --config ${cfg.configFile} --adapter caddyfile";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      requires = [ "network-online.target" ];
    };
  };
}
