{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.sing-box;
in
{
  options = {
    services.sing-box = {
      enable = mkEnableOption "Enable sing-box daemon";
      package = mkOption {
        type = types.package;
        default = pkgs.sing-box;
      };
      configPath = mkOption {
        type = types.path;
        description = ''
          Path to the sing-box configuration file.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    launchd.daemons.sing-box = {
      script = ''
        if [ ! -d /tmp/sing-box ]; then
          mkdir -p /tmp/sing-box
        fi
        if [ ! -d /var/lib/sing-box ]; then
          mkdir -p /var/lib/sing-box
        fi
        ${pkgs.sing-box}/bin/sing-box run -c ${cfg.configPath} -D /var/lib/sing-box --disable-color
      '';
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;

        StandardOutPath = "/tmp/sing-box/stdout.log";
        StandardErrorPath = "/tmp/sing-box/stderr.log";
      };
    };
  };
}
