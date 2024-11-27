{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.self-hosted.unguarded;
in
{
  options.services.self-hosted.unguarded = {
    enable = mkEnableOption "unguarded service";

    package = mkOption {
      type = types.package;
      default = pkgs.unguarded;
      description = "The unguarded package to use";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1:8787";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.unguarded = {
      serviceConfig = {
        Type = "simple";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        ExecStart = "${cfg.package}/bin/unguarded -addr ${cfg.address}";
      };
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
      requires = [ "network-online.target" ];
    };
  };
}
