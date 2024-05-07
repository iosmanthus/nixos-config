{ config
, pkgs
, ...
}: {
  imports = [
    ./fonts.nix
    ./monitors.nix
    ./fcitx5.nix
  ];

  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.dconf.enable = true;

  services.dbus = {
    enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  services.xserver = {
    enable = true;
    # Unlock auto unlock gnome-keyring for i3 and other WMs that don't use a display manager
    updateDbusEnvironment = true;
    xkb.layout = "us";
    autoRepeatInterval = 20;
    autoRepeatDelay = 200;
    displayManager.lightdm = {
      enable = true;
      background = config.wallpaper.package.gnomeFilePath;
      greeters.gtk = {
        enable = true;
        cursorTheme = {
          package = pkgs.yaru-theme;
          name = "Yaru";
          size = 48;
        };
        theme = config.gtk.globalTheme;
        indicators =
          [ "~host" "~spacer" "~clock" "~spacer" "~session" "~power" ];
        extraConfig = ''
          xft-dpi=192
          font-name=sans-serif
        '';
      };
    };
    windowManager.i3 = { enable = true; };
  };
}
