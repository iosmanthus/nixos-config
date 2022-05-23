{ pkgs
, ...
}:
let
  wallPaperCommit = "374482a43a8c266924d8eda210a82ac359820c9c";
  wallPaperSha256 = "05ypq2lgc50frb5w56gkhpx8q4bjxrk5lw18qz71adzchy788ppb";
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/small-tech/catts/${wallPaperCommit}/wallpapers/catts-wallpaper-4k-by-margo-de-weerdt-small-technology-foundation.jpg";
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

  xsession = {
    enable = true;
    profileExtra = ''
      eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
      export SSH_AUTH_SOCK
    '';
  };

  home.pointerCursor = {
    x11.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
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

  # home.file = {
  #   wallpaper = {
  #     source = wallpaper;
  #     target = ".background-image";
  #   };
  # };
}
