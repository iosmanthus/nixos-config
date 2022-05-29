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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  home.packages = with pkgs;[
    fcitx5-configtool
  ];

  home.immutable-file = {
    fcitx5-profile = {
      src = ./profile;
      dst = "${fcitx5Home}/profile";
    };

    fcitx5-config = {
      src = ./config;
      dst = "${fcitx5Home}/config";
    };

    fcitx5-chttrans = {
      src = ./chttrans.conf;
      dst = "${fcitx5Home}/conf/chttrans.conf";
    };

    fcitx5-clipboard = {
      src = ./clipboard.conf;
      dst = "${fcitx5Home}/conf/clipboard.conf";
    };

    fcitx5-cloudpinyin = {
      src = ./cloudpinyin.conf;
      dst = "${fcitx5Home}/conf/cloudpinyin.conf";
    };

    fcitx5-notifications = {
      src = ./notifications.conf;
      dst = "${fcitx5Home}/conf/notifications.conf";
    };

    fcitx5-pinyin = {
      src = ./pinyin.conf;
      dst = "${fcitx5Home}/conf/pinyin.conf";
    };

    fcitx5-punctuation = {
      src = ./punctuation.conf;
      dst = "${fcitx5Home}/conf/punctuation.conf";
    };

    fcitx5-classicui = {
      src = ./classicui.conf;
      dst = "${fcitx5Home}/conf/classicui.conf";
    };
  };

  xdg.dataFile."fcitx5/themes/fcitx5-adwaita-dark".source = pkgs.fcitx5-adwaita-dark;

  xdg.dataFile."fcitx5/pinyin/dictionaries/zhwiki.dict".source = pkgs.fcitx5-pinyin-zhwiki;
}
