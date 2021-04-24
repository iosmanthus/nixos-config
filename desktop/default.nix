{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./vscode.nix
    ./input-method.nix
    ./gdm-tapping.nix
  ];

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  programs.geary.enable = false;
  environment.systemPackages = with pkgs;[
    gnome3.gnome-tweaks
    gnome3.dconf-editor
    gnomeExtensions.appindicator

    tilix
    thunderbird
    zoom-us
    glib.dev
    firefox
    discord
    flameshot
    jetbrains.goland
    tdesktop
    feeluown
  ];

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
    extraConfig = {
      tapping = true;
    };
  };

  services.xserver.desktopManager.gnome3.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
}
