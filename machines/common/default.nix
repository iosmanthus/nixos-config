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
    displayPorts = mkOption {
      type = types.submodule {
        options = {
          builtin = mkOption {
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
          extra = mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
        };
      };
    };
    hashedPassword = mkOption {
      type = types.str;
    };
    shell = mkOption {
      type = types.package;
    };
    gpgPubKey = mkOption {
      type = types.str;
    };
  };
}
