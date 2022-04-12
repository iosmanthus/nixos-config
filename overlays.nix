_self: super:
with super;
{
  firmwareLinuxNonfree = firmwareLinuxNonfree.overrideAttrs (_: rec {
    version = "2021-05-11";
    src = fetchgit {
      url =
        "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
      rev = "refs/tags/" + lib.replaceStrings [ "-" ] [ "" ] version;
      sha256 = "sha256-vGPty0+ZzGzRbbyVm27nEbdPRtxe88Kh2A3hOpxUsAQ=";
    };
    outputHash = "sha256-yrygxx8Q9/Z1LXkotkWI/N/6W/p+LwbpoX+bYOjiiww=";
  });

  leaf = super.callPackage ./packages/leaf.nix { };

  polybar-fonts = super.callPackage ./packages/polybar-fonts.nix { };

  tun2socks = super.callPackage ./packages/tun2socks.nix { };

  yesplaymusic = super.callPackage ./packages/yesplaymusic.nix { };

  base16-kitty = super.callPackage ./packages/base16-kitty.nix { };

  base16-rofi = super.callPackage ./packages/base16-rofi.nix { };
}
