{ lib
, ...
}:
with lib;
{
  options.dns = {
    servers = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
}
