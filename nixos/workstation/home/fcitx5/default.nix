{ config
, lib
, pkgs
, ...
}:
with lib ;
let
  fcitx5Home = "${config.xdg.configHome}/fcitx5";
in
{
  home.packages = with pkgs; [
    fcitx5-configtool
  ];

  home.immutable-file = {
    fcitx5-profile = {
      src = ./profile;
      dst = "${fcitx5Home}/profile";
    };
  };
}
