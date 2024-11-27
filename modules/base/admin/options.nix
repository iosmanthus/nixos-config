{ lib, ... }:
with lib;
let
  adminOpts =
    { ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
        };
        email = mkOption {
          type = types.str;
          default = "";
        };
        home = mkOption {
          type = types.str;
        };
        shell = mkOption {
          type = types.package;
        };
        hashedPasswordFile = mkOption {
          type = with types; nullOr path;
          default = null;
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
  options.admin = mkOption { type = types.submodule adminOpts; };
}
