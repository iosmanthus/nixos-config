{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.self-hosted.sing-box;

  singboxOpts =
    { ... }:
    {
      options = {
        enable = mkEnableOption "sing-box";

        package = mkOption {
          type = types.package;
          default = pkgs.sing-box;
        };

        configFile = mkOption { type = types.path; };
      };
    };

  writeShScript =
    name: text:
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
in
{
  options.services.self-hosted.sing-box = mkOption { type = with types; (submodule singboxOpts); };

  config = mkIf cfg.enable {
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
  };
}
