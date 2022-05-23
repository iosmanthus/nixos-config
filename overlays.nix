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
    url = "https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb";
    sha256 = "199psf7q6f87mmg1jsnn1gkszmg16cv2wgi3pi7mbdjgyc6n7b2w";
  };

  leaf = super.callPackage ./packages/leaf.nix { };

  polybar-fonts = super.callPackage ./packages/polybar-fonts.nix { };

  tun2socks = super.callPackage ./packages/tun2socks.nix { };

  yesplaymusic = super.callPackage ./packages/yesplaymusic.nix { };

  base16-kitty = super.callPackage ./packages/base16-kitty.nix { };

  base16-rofi = super.callPackage ./packages/base16-rofi.nix { };

  fcitx5-material-color = super.callPackage ./packages/fcitx5-material-color.nix { };

  fcitx5-adwaita-dark = super.callPackage ./packages/fcitx5-adwaita-dark.nix { };

  fcitx5-pinyin-zhwiki = super.callPackage ./packages/fcitx5-pinyin-zhwiki.nix { };
}
