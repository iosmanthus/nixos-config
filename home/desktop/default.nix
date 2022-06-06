{ pkgs
, ...
}:
let
  wallpaperCommit = "03c6c20be96c38827037d2238357f2c777ec4aa5";
  wallpaperSha256 = "1fcbbwz1mnzinwjzbhp5ygg7w1rz41fgcjs64aw4ffzw5v6pbs9y";
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/${wallpaperCommit}/wallpapers/nix-wallpaper-nineish-dark-gray.svg";
    sha256 = wallpaperSha256;
  };
in
{
  imports = [
    ./i3.nix
    ./dunst.nix
  ];

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.pointerCursor = {
    x11.enable = true;
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 48;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };
    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  services.clipmenu = { enable = true; };

  home.file = {
    wallpaper = {
      source = wallpaper;
      target = ".background-image";
    };
  };
}
