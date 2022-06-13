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

  leaf = super.callPackage ./packages/leaf.nix { };

  polybar-fonts = super.callPackage ./packages/polybar-fonts.nix { };

  tun2socks = super.callPackage ./packages/tun2socks.nix { };

  yesplaymusic = super.callPackage ./packages/yesplaymusic.nix { };

  base16-kitty = super.callPackage ./packages/base16-kitty.nix { };

  base16-rofi = super.callPackage ./packages/base16-rofi.nix { };

  fcitx5-material-color = super.callPackage ./packages/fcitx5-material-color.nix { };

  fcitx5-adwaita-dark = super.callPackage ./packages/fcitx5-adwaita-dark.nix { };

  fcitx5-pinyin-zhwiki = super.callPackage ./packages/fcitx5-pinyin-zhwiki.nix { };

  lxgw-wenkai = super.callPackage ./packages/lxgw-wenkai.nix { };

  segoe-ui = super.callPackage ./packages/segoe-ui.nix { };
}
