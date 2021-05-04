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
  programs.evolution.enable = true;

  environment.systemPackages = with pkgs;[
    gnome3.gnome-tweaks
    gnome3.dconf-editor

    flameshot
    zoom-us
    glib.dev
    firefox
    discord
    google-chrome
    jetbrains.goland
    tdesktop
    feeluown
  ];
  services.picom.refreshRate = 60;

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
}
