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
    "Xft.dpi" = 96;
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
    package = pkgs.bibata-cursors;
    name = "bibata-cursors";
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

  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 10;
    arguments = [ "dim" ];
  };

  home.file = {
    wallpaper = {
      source = wallpaper;
      target = ".background-image";
    };
  };
}
