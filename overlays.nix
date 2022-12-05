_self: super:
with super;
{
  leaf = callPackage ./packages/leaf.nix { };

  polybar-fonts = callPackage ./packages/polybar-fonts.nix { };

  tun2socks = callPackage ./packages/tun2socks.nix { };

  yesplaymusic = callPackage ./packages/yesplaymusic.nix { };

  base16-rofi = callPackage ./packages/base16-rofi.nix { };

  fcitx5-material-color = callPackage ./packages/fcitx5-material-color.nix { };

  fcitx5-adwaita-dark = callPackage ./packages/fcitx5-adwaita-dark.nix { };

  fcitx5-pinyin-zhwiki = callPackage ./packages/fcitx5-pinyin-zhwiki.nix { };

  lxgw-wenkai = callPackage ./packages/lxgw-wenkai.nix { };

  segoe-ui = callPackage ./packages/segoe-ui.nix { };

  apple-fonts = callPackage ./packages/apple-fonts.nix { };

  sf-mono = callPackage ./packages/sf-mono.nix { };

  clash-data = callPackage ./packages/clash-data.nix { };

  kitty-themes = callPackage ./packages/kitty-themes.nix { };

  python3Builder = callPackage ./packages/python3-builder.nix { };

  runVscode = import ./packages/scripts/run-vscode.nix {
    pkgs = super;
  };
}
