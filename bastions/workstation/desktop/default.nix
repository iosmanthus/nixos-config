{ config, pkgs, ... }:
{
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

  services.gnome.at-spi2-core.enable = true;
  services.accounts-daemon.enable = true;
  services.gnome.glib-networking.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  services.displayManager = {
    defaultSession = "none+i3";
  };

  services.xserver = {
    enable = true;
    # Unlock auto unlock gnome-keyring for i3 and other WMs that don't use a display manager
    updateDbusEnvironment = true;
    xkb.layout = "us";
    xkb.options = "caps:escape";
    autoRepeatInterval = 20;
    autoRepeatDelay = 200;
    desktopManager.xterm.enable = false;
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
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus";
        };
        theme = config.gtk.globalTheme;
        indicators = [
          "~host"
          "~spacer"
          "~clock"
          "~spacer"
          "~session"
          "~power"
        ];
        extraConfig = ''
          xft-dpi=192
          font-name=sans-serif
          user-background=false
        '';
      };
    };
    windowManager.i3 = {
      enable = true;
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.file-roller.enable = true;
}
