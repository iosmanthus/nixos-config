_self: super:
with super;
{
  firmwareLinuxNonfree = firmwareLinuxNonfree.overrideAttrs (_: rec {
    version = "2021-05-11";
    src = fetchgit {
      url =
        "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
      rev = "refs/tags/" + lib.replaceStrings [ "-" ] [ "" ] version;
      sha256 = "015hajf3mq8dv2hw5wsyvi34zdqiwxp9p5dwdp8nrk4r9z5ysqxw";
    };
    outputHash = "034bwbl616vzl7lhcbvyz9dzmpzwi12vca3r5mszdxqh3z3s1g6a";
  });

  mmdb = builtins.fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/20220512/Country.mmdb";
    sha256 = "1vhygp5pvkx4jq0m69v9xcxxic52ih98rlz5hq0s4fzqp12pnis0";
  };

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

  clash-rules = callPackage ./packages/clash-rules.nix { };

  kitty-themes = callPackage ./packages/kitty-themes.nix { };

  rust-analyzer-unwrapped = rust-analyzer-unwrapped.overrideAttrs (old: rec {
    version = "2022-07-04";
    src = fetchFromGitHub {
      owner = "rust-lang";
      repo = "rust-analyzer";
      rev = version;
      sha256 = "sha256-NlRtzurOh6u2FNy9H8CIJE+1pDB9M4J70YsJIKsh1iA=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
      name = "rust-analyzer-vendor.tar.gz";
      inherit src;
      outputHash = "15xczaqrrqr1cs69gppxywzcv1vyq4yb64d1am8sxcnlzmfip4i8";
    });

  });
}
