{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
  ];

  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.autorandr.enable = true;
  services.dbus = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };
    autoRepeatInterval = 20;
    autoRepeatDelay = 200;
    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          cursorTheme = {
            package = pkgs.vanilla-dmz;
            name = "Vanilla-DMZ";
          };
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
            font-name=Roboto
          '';
        };
      };
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs;[ hplip ];
  };
}
