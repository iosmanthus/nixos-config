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
    inherit pkgs;
  };

  graphite-gtk-theme = super.graphite-gtk-theme.overrideAttrs (_: {
    version = "unstable-2022-12-10";
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "966e98c4ea348f739594f65eae8b824abdb1a1b4";
      sha256 = "0hc3hdvb24f2fnxbggdk30frqh6cqb4l7ybyb9slig6qivi6wnda";
    };
  });
} 
