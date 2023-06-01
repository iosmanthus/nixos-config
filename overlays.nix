_self: super:
with super;
{
  leaf = callPackage ./packages/leaf { };

  polybar-fonts = callPackage ./packages/polybar-fonts.nix { };

  tun2socks = callPackage ./packages/tun2socks.nix { };

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

  yesplaymusic = callPackage ./packages/yesplaymusic.nix { };

  sing-box = callPackage ./packages/sing-box.nix { };

  graphite-gtk-theme = super.graphite-gtk-theme.overrideAttrs (_: {
    version = "unstable-2023-03-31";
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "54b3cf69ceb4ca204d38dda9d19f4f1bdbcf5739";
      sha256 = "1h090lish16l36pabwkfnd469dp0pmlp6j1qy9ww21mg3rfrnmqz";
    };
  });

  fluent-gtk-theme = super.fluent-gtk-theme.overrideAttrs (_: {
    version = "unstable-2023-03-31";
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-gtk-theme";
      rev = "7fc847caf4bd226c937272faeab2946a5ae84ef5";
      sha256 = "02sgpv89gqqixny7cmv2b7khpia7y3fd7i8qc9vdc1qpw47sb64j";
    };
  });

  colloid-gtk-theme = super.colloid-gtk-theme.overrideAttrs (_: {
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Colloid-gtk-theme";
      rev = "6cba9239b8d04e82171899211fb6df2455d6a89d";
      sha256 = "16wzhracfxn7cjzyz8dalrr6rd53wxvh1lcxcc13ssn02v7202z3";
    };
  });

  feishu = super.feishu.override {
    commandLineArgs = "--disable-features=AudioServiceSadbox";
    nss = super.nss_latest;
  };

  apx = super.apx.overrideAttrs (_: {
    postPatch = ''
      sed -i "s#/etc/apx#$out/etc/apx#g" $(find . -name "*.go")
    '';
  });
} 
