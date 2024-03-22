{ pkgs
, config
, lib
, ...
}:
with lib;
let
  singboxOpts = { ... }: {
    options = {
      enable = mkEnableOption "sing-box";

      package = mkOption {
        type = types.package;
        default = pkgs.sing-box;
      };

      configFile = mkOption {
        type = types.path;
      };

      override = mkOption {
        type = types.attrs;
        default = { };
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

  toJSON = attrs: name:
    let
      json = builtins.toJSON attrs;
    in
    pkgs.writeText name json;

  singboxStart = writeShScript "singbox-start" ''
    override=${toJSON cfg.override "override.json"}
    jq -s '.[0] * .[1]' ${cfg.configFile} $override > $RUNTIME_DIRECTORY/config.json
    sing-box run -C $RUNTIME_DIRECTORY -D $STATE_DIRECTORY --disable-color
  '';

  cfg = config.services.self-hosted.sing-box;
in
{
  options.services.self-hosted.sing-box = mkOption {
    type = with types; (submodule singboxOpts);
  };

  config = mkIf cfg.enable {
    systemd.services.sing-box = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Enable sing-box services";
      path = [ cfg.package ] ++ (with pkgs; [ jq ]);
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
