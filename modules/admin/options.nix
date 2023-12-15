{ lib
, ...
}:
with lib;
let
  adminOpts = { ... }: {
    options = {
      name = mkOption {
        type = types.str;
      };
      email = mkOption {
        type = types.str;
      };
      home = mkOption {
        type = types.str;
      };
      shell = mkOption {
        type = types.package;
      };
      hashedPassword = mkOption {
        type = types.str;
      };
      sshPubKey = mkOption {
        type = types.str;
      };
      gpgPubKey = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
in
{
  options.admin = mkOption {
    type = types.submodule adminOpts;
  };
}
