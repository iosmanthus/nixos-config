{ config
, pkgs
, ...
}: {
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
    theme = config.gtk.globalTheme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-application-prefer-dark-theme = true;
    };
    "org/gnome/gedit/preferences/editor" = {
      scheme = "Yaru-dark";
      use-default-font = false;
      wrap-last-split-mode = "word";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita";
    };
  };

  services.clipmenu = { enable = true; };

  home.file = {
    wallpaper = {
      # source = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
      source = config.wallpaper.package.gnomeFilePath;
      target = ".background-image";
    };
  };
}
