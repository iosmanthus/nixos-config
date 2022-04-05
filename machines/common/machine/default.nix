{ pkgs, lib, ... }:
with lib;
{
  options.machine = {
    userName = mkOption {
      type = types.str;
    };
    userEmail = mkOption {
      type = types.str;
    };
    displayPort = mkOption {
      type = types.str;
    };
    hashedPassword = mkOption {
      type = types.str;
    };
    shell = mkOption {
      type = types.package;
    };
  };
}
