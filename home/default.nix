{ config, pkgs, ... }:

let
  mkKittyBase16Theme = name:
    "${pkgs.base16-kitty}/share/base16-kitty/colors/base16-${name}.conf";
in
{
  imports = [
    ./fcitx5.nix
    ./firefox.nix
    ./media.nix
    ./rofi.nix
    ./tmux.nix

    ./desktop
    ./polybar
    ./shell
    ./vscode
  ];

  home.packages = with pkgs; [
    gh
    cloc
    tree
    ripgrep
    fd
    htop
    speedtest-cli
    ihaskell
    rustup
    httpie
    nnn
    nix-output-monitor
    feeluown
    gnome.gnome-system-monitor
    gnome.gnome-font-viewer
    imagemagick
    geoipWithDatabase
    peek
    vlc

    sops
    iperf3
    yesplaymusic
    flameshot
    thunderbird
    zoom-us
    discord
    google-chrome
    jetbrains.goland
    jetbrains.idea-ultimate
    jetbrains.clion
    jetbrains.pycharm-professional
    tdesktop
    slack
    wireguard-tools
    notion-app-enhanced
  ];

  home.sessionVariables = {
    "TERMINAL" = "${pkgs.kitty}/bin/kitty";
  };

  home.keyboard.options = [ "caps:escape" ];

  programs.feh.enable = true;

  programs.git = {
    enable = true;
    userName = config.machine.userName;
    userEmail = config.machine.userEmail;
    extraConfig = {
      core = { editor = "${pkgs.vscode}/bin/code --wait"; };
      pull = { rebase = false; };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.gpg = { enable = true; };

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      allow-preset-passphrase
    '';
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };

  programs.kitty = {
    enable = true;
    font = { name = "Meslo LG M"; };
    settings = {
      include = mkKittyBase16Theme "material-darker";
    };
  };

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
  };
}
