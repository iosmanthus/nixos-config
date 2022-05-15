{ config
, pkgs
, lib
, ...
}: {
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
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 48;
    };
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

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  services.clipmenu = { enable = true; };
}
