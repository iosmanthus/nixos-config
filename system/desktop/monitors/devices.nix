{ lib
, ...
}:
with lib;
let
  monitorOpts = { ... }: {
    options = {
      fingerprint = mkOption {
        type = types.str;
      };
    };
  };
in
{
  options.monitors = mkOption {
    type = with types; attrsOf (submodule monitorOpts);
    default = { };
  };
}
