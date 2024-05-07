{ pkgs
, config
, lib
, ...
}:
with lib;
let
  cfg = config.services.self-hosted.gemini-openai-proxy;
in
{
  options.services.self-hosted.gemini-openai-proxy = {
    enable = mkEnableOption "gemini-openai-proxy";
    package = mkOption {
      type = types.package;
      default = pkgs.gemini-openai-proxy;
      description = ''
        The package to use for the Gemini OpenAI proxy.
      '';
    };
    port = mkOption {
      type = types.int;
      description = ''
        The port on which the Gemini OpenAI proxy will listen.
      '';
    };
  };
  config = mkIf cfg.enable {
    systemd.services.gemini-openai-proxy = {
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/gemini-openai-proxy -port ${toString cfg.port}";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
      requires = [ "network-online.target" ];
    };
  };
}
