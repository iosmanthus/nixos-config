{ lib, ... }:
with lib;
{
  options.wallpaper = {
    package = mkOption { type = types.package; };
  };
}
