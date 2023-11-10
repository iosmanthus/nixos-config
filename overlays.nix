_self: super:
with super;
{
  leaf = callPackage ./packages/leaf { };

  polybar-fonts = callPackage ./packages/polybar-fonts.nix { };

  tun2socks = callPackage ./packages/tun2socks.nix { };

  base16-rofi = callPackage ./packages/base16-rofi.nix { };

  fcitx5-material-color = callPackage ./packages/fcitx5-material-color.nix { };

  fcitx5-adwaita-dark = callPackage ./packages/fcitx5-adwaita-dark.nix { };

  lxgw-wenkai = callPackage ./packages/lxgw-wenkai.nix { };

  segoe-ui = callPackage ./packages/segoe-ui.nix { };

  apple-fonts = callPackage ./packages/apple-fonts.nix { };

  sf-mono = callPackage ./packages/sf-mono.nix { };

  clash-data = callPackage ./packages/clash-data.nix { };

  kitty-themes = callPackage ./packages/kitty-themes.nix { };

  python3Builder = callPackage ./packages/python3-builder.nix { };

  jetbrains-nerd-font = callPackage ./packages/jetbrains-nerd-font.nix { };

  runVscode = import ./packages/utils/run-vscode.nix {
    inherit pkgs;
  };

  mkNixBackground = import ./packages/utils/nix-background.nix {
    inherit stdenv lib;
  };

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
      rev = "995f6a377053560c560d026be7761985a9346e36";
      sha256 = "1zxwna7k04h5h37il1zk7f4pd1p45j52fmg9sqvg58zvpi4bwzvj";
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

  feishu = (super.feishu.override {
    commandLineArgs = "--disable-features=AudioServiceSandbox";
    nss = super.nss_latest;
  }).overrideAttrs (_: rec {
    version = "6.5.14";
    packageHash = "833ac8e9";
    src = fetchurl {
      url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/${packageHash}/Feishu-linux_x64-${version}.deb";
      sha256 = "1y8amx0g2far30pfwzympbr0vzyk8afng13ndv1kf78g244wv4cp";
    };
  });

  vistafonts-chs = super.vistafonts-chs.overrideAttrs (_: {
    src = fetchurl {
      url = "https://github.com/iosmanthus/nowhere/releases/download/v0.1.0/VistaFont_CHS.EXE";
      sha256 = "1qwm30b8aq9piyqv07hv8b5bac9ms40rsdf8pwix5dyk8020i8xi";
    };
  });

  apx = super.apx.overrideAttrs (_: {
    postPatch = ''
      sed -i "s#/etc/apx#$out/etc/apx#g" $(find . -name "*.go")
    '';
  });

  btrfs-progs = super.btrfs-progs.overrideAttrs (_: rec {
    version = "6.6.1";
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
      hash = "sha256-PpLLbYO93mEjGP2ARt1u/0fHhuWdVt1Ozph5RdUTfJ4=";
    };
  });
} 
