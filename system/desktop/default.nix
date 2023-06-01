{ config
, pkgs
, ...
}: {
  imports = [
    ./monitors

    ./fonts.nix
  ];

  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.dconf.enable = true;

  services.dbus = {
    enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  services.xserver = {
    enable = true;
    # Unlock auto unlock gnome-keyring for i3 and other WMs that don't use a display manager
    updateDbusEnvironment = true;
    layout = "us";
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };
    autoRepeatInterval = 20;
    autoRepeatDelay = 200;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
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
            font-name=SF Pro Text
          '';
        };
      };
    };

    windowManager.i3 = { enable = true; };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };
}
