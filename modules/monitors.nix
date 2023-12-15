{ lib
, ...
}:
with lib;
let
  externalMonitorOpts = { ... }: {
    options = {
      fingerprint = mkOption {
        type = types.str;
      };
    };
  };
  builtinMonitorOpts = { ... }: {
    options = {
      name = mkOption {
        type = types.str;
      };
      fingerprint = mkOption {
        type = types.str;
      };
      ports = mkOption {
        type = with types; listOf str;
      };
    };
  };
in
{
  options.monitors = {
    builtin = mkOption {
      type = types.submodule builtinMonitorOpts;
    };
    external = mkOption {
      type = with types; attrsOf (submodule externalMonitorOpts);
    };
  };
}
