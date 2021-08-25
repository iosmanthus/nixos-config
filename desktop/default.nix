{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./input-method.nix
    #./gdm-tapping.nix
  ];

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.evolution.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs;[
    flameshot
    zoom-us
    firefox-bin
    discord
    google-chrome
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.clion
    tdesktop
    feeluown
    slack
  ];
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
