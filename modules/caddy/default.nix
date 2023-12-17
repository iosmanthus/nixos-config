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

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/caddy";
      description = "The directory to store Caddy's data in.";
    };

    group = mkOption {
      type = types.str;
      default = "caddy";
      description = "The group to run Caddy as.";
    };

    user = mkOption {
      type = types.str;
      default = "caddy";
      description = "The user to run Caddy as.";
    };

    configFile = mkOption {
      type = types.path;
      description = "Path to the Caddy configuration file.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == "caddy") {
      caddy = {
        inherit (cfg) group;
        uid = config.ids.uids.caddy;
        home = cfg.dataDir;
      };
    };

    users.groups = optionalAttrs (cfg.group == "caddy") {
      caddy.gid = config.ids.gids.caddy;
    };

    systemd.services.caddy = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/caddy") [ "caddy" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        ExecStart = "${cfg.package}/bin/caddy run --watch --config ${cfg.configFile} --adapter caddyfile";
        Restart = "on-failure";
        RestartPreventExitStatus = 1;
        RestartSec = "5s";

        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectHome = true;
      };
    };
  };
}
