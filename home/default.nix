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
    ascii
    gh
    cloc
    tree
    ripgrep
    fd
    htop
    speedtest-cli
    ihaskell
    httpie
    mycli
    mysql
    nnn
    nix-output-monitor
    xfce.thunar
    xfce.xfce4-taskmanager
    gnome.gnome-font-viewer
    gnome.seahorse
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
    unzip
    wireguard-tools
    notion-app-enhanced
    feishu
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
    lfs.enable = true;
    userName = config.machine.userName;
    userEmail = config.machine.userEmail;
    extraConfig = {
      core = { editor = "${pkgs.vscode}/bin/code --wait"; };
      pull = { rebase = false; };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
    signing = {
      key = config.machine.gpgPubKey;
      signByDefault = true;
    };
  };

  home.file = {
    cargoConfig = {
      text = ''
        [net]
        git-fetch-with-cli = true
      '';
      target = ".cargo/config.toml";
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


  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
