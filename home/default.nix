{ lib
, config
, pkgs
, ...
}: {
  imports = [
    ./firefox.nix
    ./media.nix
    ./rofi.nix
    ./tmux.nix

    ./desktop
    ./fcitx5
    ./flameshot
    ./polybar
    ./shell
    ./vscode
  ];

  home.stateVersion = "18.09";

  home.packages = with pkgs; [
    gh
    cloc
    tree
    ripgrep
    fd
    htop
    speedtest-cli
    ihaskell
    httpie
    nnn
    nix-output-monitor
    xfce.thunar
    xfce.xfce4-taskmanager
    gnome.gnome-font-viewer
    imagemagick
    geoipWithDatabase
    peek
    vlc
    pavucontrol
    sops
    iperf3
    yesplaymusic
    flameshot
    thunderbird
    zoom-us
    discord
    google-chrome
    tdesktop
    slack
    wireguard-tools
    notion-app-enhanced
  ] ++ (with pkgs.jetbrains ;[
    clion
    goland
    idea-ultimate
    pycharm-professional
  ]);

  home.sessionVariables = {
    "TERMINAL" = "${pkgs.kitty}/bin/kitty";
  };

  home.activation = {
    createGoPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $HOME/.go
    '';
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
    };
    signing = {
      key = config.machine.gpgPubKey;
      signByDefault = true;
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
    font = { name = "monospace"; };
    settings = {
      include = pkgs.kitty-themes.mkKittyTheme "base16-material-darker";
    };
  };

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
  };

  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
    };
  };
}
