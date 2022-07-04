{ config
, pkgs
, ...
}: {
  imports = [
    ./fonts.nix
    ./monitors.nix
  ];

  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.dconf.enable = true;

  services.dbus = {
    enable = true;
  };

  services.xserver = {
    enable = true;
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
          theme = {
            package = pkgs.orchis-theme;
            name = "Orchis";
          };
          indicators =
            [ "~host" "~spacer" "~clock" "~spacer" "~session" "~power" ];
          extraConfig = ''
            xft-dpi=192
            font-name=SF Pro Text
          '';
        };
      };
      defaultSession = "none+i3";
    };
    windowManager.i3 = { enable = true; };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };
}
