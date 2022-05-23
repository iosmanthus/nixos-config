{ lib
, ...
}:
with lib;
{
  options.machine = {
    userName = mkOption {
      type = types.str;
    };
    userEmail = mkOption {
      type = types.str;
    };
    builtinDisplayPort = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          fingerprint = mkOption {
            type = types.str;
          };
        };
      };
    };
    displayPorts = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    hashedPassword = mkOption {
      type = types.str;
    };
    shell = mkOption {
      type = types.package;
    };
  };
}
