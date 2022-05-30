{ config
, ...
}: {
  home.immutable-file = {
    flameshot-config = {
      src = ./flameshot.ini;
      dst = "${config.xdg.configHome}/flameshot/flameshot.ini";
    };
  };
}
