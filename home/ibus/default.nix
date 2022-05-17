{ lib
, pkgs
, ...
}:
with lib ;
{
  dconf.settings = with lib.hm.gvariant; {
    "com/github/libpinyin/ibus-libpinyin/libpinyin" = {
      cloud-input-source = 1;
      display-style = 0;
      double-pinyin = true;
      enable-cloud-input = true;
      lookup-table-page-size = 10;
      show-suggestion = true;
      sort-candidate-option = 0;
    };
    "desktop/ibus/general" = {
      engines-order = mkArray type.string [ "xkb:us::eng" "libpinyin" ];
      preload-engines = mkArray type.string [ "libpinyin" "xkb:us::eng" ];
    };
    "desktop/ibus/general/hotkey" = {
      triggers = mkArray type.string [ "<Shift>space" ];
    };
    "desktop/ibus/panel" = {
      lookup-table-orientation = 0;
      show = 0;
    };
  };
}
