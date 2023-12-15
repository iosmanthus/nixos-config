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
      restartTriggers = mkOption {
        type = with types;listOf unspecified;
        default = [ ];
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

  saveAsJson = attrs: name:
    let
      json = builtins.toJSON attrs;
    in
    pkgs.writeText name json;

  singboxStart = writeShScript "singbox-start" ''
    override=${saveAsJson cfg.override "override.json"}
    jq -s '.[0] * .[1]' ${cfg.configFile} $override > $RUNTIME_DIRECTORY/config.json
    sing-box run -C $RUNTIME_DIRECTORY -D $STATE_DIRECTORY --disable-color
  '';

  cfg = config.iosmanthus.sing-box;
in
{
  options.iosmanthus.sing-box = mkOption {
    type = with types; (submodule singboxOpts);
  };

  config = mkIf cfg.enable {
    systemd.services.iosmanthus-sing-box = {
      inherit (cfg) restartTriggers;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Enable sing-box services";
      path = [ cfg.package ] ++ (with pkgs; [ jq ]);
      serviceConfig = {
        RuntimeDirectory = "sing-box";
        StateDirectory = "sing-box";
        Type = "simple";
        ExecStart = "${singboxStart}";
      };
    };
  };
}
