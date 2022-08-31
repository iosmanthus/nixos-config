{ pkgs
, ...
}:
let
  wallPaperCommit = "da01f68d21ddfdc9f1c6e520c2170871c81f1cf5";
  wallPaperSha256 = "0a7501pq29h1fbg35ih3zjhsdqgjlcaxi7gz780cgd8yvzgikhld";
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/${wallPaperCommit}/wallpapers/nix-wallpaper-nineish.src.svg";
    sha256 = wallPaperSha256;
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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.quintom-cursor-theme;
    name = "quintom-cursor-theme-unstable";
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
      source = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
      target = ".background-image";
    };
  };
}
