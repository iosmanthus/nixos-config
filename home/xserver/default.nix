{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./i3.nix
    ./rofi.nix
    ./polybar
  ];

  xresources.properties = {
    "Xft.dpi" = 216;
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
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
    ];
  };

  services.clipmenu = { enable = true; };

  services.mpd.enable = true;
  services.mpris-proxy.enable = true;
  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
    notifications = true;
  };
}
