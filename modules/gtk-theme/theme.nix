{ lib
, ...
}:
with lib;
{
  options.gtk.globalTheme = {
    package = mkOption {
      type = types.package;
    };
    name = mkOption {
      type = types.str;
    };
  };
}
