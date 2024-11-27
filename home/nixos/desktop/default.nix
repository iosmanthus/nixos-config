{ config, pkgs, ... }:
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
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 48;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = config.gtk.globalTheme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    # style = {
    #   package = pkgs.adwaita-qt;
    #   name = "adwaita";
    # };
  };

  services.clipmenu = {
    enable = true;
  };

  home.file = {
    wallpaper = {
      # source = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
      source = config.wallpaper.package.gnomeFilePath;
      target = ".background-image";
    };

    avatar = {
      source = builtins.fetchurl {
        url = "https://gravatar.com/avatar/fdcfd2db68736d75fb10045eca3da214c4c2e4afb291124f0e3ae1c74c6a77a4?size=200";
        sha256 = "1bzzfg8lnay8lcmn1fjrrv51rcp7arr28qfk928hnw74w72pp8ck";
      };
      target = ".face";
    };
  };
}
