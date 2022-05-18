{ config
, lib
, pkgs
, ...
}:
with lib ;
{

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  home.packages = with pkgs;[
    fcitx5-configtool
  ];

  # The trick here is to create immutable file to prevent overriding from fcitx5
  home.activation = {
    mkFcitx5Config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # $1: dst
      # $2: src
      function mk_immutable_file() {
        if [ -f $1 ]; then
          sudo chattr -i $1
        fi
        cp $2 $1
        sudo chattr +i $1
      }

      fcitx5_home=${config.xdg.configHome}/fcitx5
      mkdir -p ''${fcitx5_home}/conf

      mk_immutable_file ''${fcitx5_home}/profile ${builtins.toPath ./profile}
      mk_immutable_file ''${fcitx5_home}/config ${builtins.toPath ./config}
      mk_immutable_file ''${fcitx5_home}/conf/chttrans.conf ${builtins.toPath ./chttrans.conf}
      mk_immutable_file ''${fcitx5_home}/conf/clipboard.conf ${builtins.toPath ./clipboard.conf}
      mk_immutable_file ''${fcitx5_home}/conf/cloudpinyin.conf ${builtins.toPath ./cloudpinyin.conf}
      mk_immutable_file ''${fcitx5_home}/conf/notifications.conf ${builtins.toPath ./notifications.conf}
      mk_immutable_file ''${fcitx5_home}/conf/pinyin.conf ${builtins.toPath ./pinyin.conf}
      mk_immutable_file ''${fcitx5_home}/conf/punctuation.conf ${builtins.toPath ./punctuation.conf}
    '';
  };
}
