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

  graphite-gtk-theme = super.graphite-gtk-theme.overrideAttrs (_: {
    version = "unstable-2022-12-10";
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Graphite-gtk-theme";
      rev = "966e98c4ea348f739594f65eae8b824abdb1a1b4";
      sha256 = "0hc3hdvb24f2fnxbggdk30frqh6cqb4l7ybyb9slig6qivi6wnda";
    };
  });

  colloid-gtk-theme = (super.colloid-gtk-theme.override {
    tweaks = [ "normal" ];
    colorVariants = [ "dark" ];
  }).overrideAttrs (_: {
    src = super.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Colloid-gtk-theme";
      rev = "6cba9239b8d04e82171899211fb6df2455d6a89d";
      sha256 = "16wzhracfxn7cjzyz8dalrr6rd53wxvh1lcxcc13ssn02v7202z3";
    };
  });

  feishu = (super.feishu.override {
    commandLineArgs = "--disable-features=AudioServiceSadbox";
    nss = super.nss_latest;
  }).overrideAttrs (_: rec {
    version = "5.30.15";
    packageHash = "a1d34187be81";
    src = fetchurl {
      url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/${packageHash}/Feishu-linux_x64-${version}.deb";
      sha256 = "0v7qv4lldv0kxhq8dycjs0c2n33r38br7qqvrnj9s4x3jydln8k6";
    };
  });

  apx = super.apx.overrideAttrs (_: {
    postPatch = ''
      sed -i "s#/etc/apx#$out/etc/apx#g" $(find . -name "*.go")
    '';
  });
} 
