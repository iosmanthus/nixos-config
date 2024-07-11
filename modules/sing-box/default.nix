{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.services.self-hosted.sing-box;

  autoUpdateCfg = cfg.autoUpdate;

  autoUpdateOpts = { ... }: {
    options = {
      enable = mkEnableOption "enable config auto-update";

      package = mkOption {
        type = types.package;
        default = pkgs.sing-box-updater;
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
        default = null;
      };

      interval = mkOption {
        type = types.str;
        default = "15m";
      };
    };
  };

  singboxOpts = { ... }: {
    options = {
      enable = mkEnableOption "sing-box";

      autoUpdate = mkOption {
        type = with types; nullOr (submodule autoUpdateOpts);
        default = null;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.sing-box;
      };

      configFile = mkOption {
        type = types.path;
      };
    };
  };

  writeShScript = name: text:
    let
      dir = pkgs.writeScriptBin name ''
        #! ${pkgs.runtimeShell} -e
        ${text}
      '';
    in
    "${dir}/bin/${name}";

  singboxStart = writeShScript "singbox-start" ''
    echo "Waiting for ${cfg.configFile} to be created";
    while ! [ -f ${cfg.configFile} ]; do
      sleep 1;
    done;
    sing-box run -c ${cfg.configFile} -D $STATE_DIRECTORY --disable-color
  '';

  updaterStart = writeShScript "singbox-updater" ''
    sing-box-updater \
      -sb-path=${cfg.package}/bin/sing-box \
      -interval=${autoUpdateCfg.interval} \
      -path=${cfg.configFile}
  '';
in
{
  options.services.self-hosted.sing-box = mkOption {
    type = with types; (submodule singboxOpts);
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.sing-box = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Enable sing-box services";
        path = [ cfg.package ];
        serviceConfig = {
          Type = "simple";
          RuntimeDirectory = "sing-box";
          StateDirectory = "sing-box";
          Restart = "on-failure";
          RestartPreventExitStatus = 1;
          RestartSec = "5s";
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

          ExecStart = "${singboxStart}";
        };
      };
    })
    (mkIf (autoUpdateCfg != null && autoUpdateCfg.enable) {
      systemd.services.sing-box-updater = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Enable sing-box config auto-update";
        path = [ autoUpdateCfg.package ];
        serviceConfig = {
          Type = "simple";
          RuntimeDirectory = "sing-box";
          Restart = "on-failure";
          RestartPreventExitStatus = 1;
          RestartSec = "5s";

          EnvironmentFile = autoUpdateCfg.environmentFile;
          ExecStart = "${updaterStart}";
        };
      };
    })
  ];
}
