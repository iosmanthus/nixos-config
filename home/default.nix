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
    apx
    ascii
    awscli2
    btop
    cloc
    delve
    discord
    fd
    feishu
    flameshot
    flyctl
    fzf
    geoipWithDatabase
    gh
    gnome.gedit
    gnome.gnome-clocks
    gnome.gnome-font-viewer
    gnome.seahorse
    go-tools
    google-chrome
    graphviz
    htop
    httpie
    imagemagick
    iperf3
    jq
    kubectl
    kubectx
    libnotify
    logseq
    mariadb
    mycli
    networkmanagerapplet
    nix-output-monitor
    nnn
    notion-app-enhanced
    pavucontrol
    peek
    regctl
    ripgrep
    slack
    sops
    speedtest-cli
    spotify-unwrapped
    ssm-session-manager-plugin
    tdesktop
    thunderbird
    tldr
    tree
    unzip
    via
    vlc
    wireguard-tools
    wmfocus
    xfce.thunar
    xfce.xfce4-taskmanager
    xxd
    yesplaymusic
    zoom-us
  ] ++ (with pkgs.jetbrains ;[
    clion
    goland
    idea-ultimate
    pycharm-professional
  ]);

  home.sessionVariables = {
    "TERMINAL" = "${pkgs.kitty}/bin/kitty";
    "LD_LIBRARY_PATH" = "${pkgs.xorg.libXcursor}/lib";
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
    inherit (config.machine) userName userEmail;
    extraConfig = {
      core = {
        editor = "${pkgs.runVscode} --wait";
        fsmonitor = true;
      };
      pull = {
        rebase = false;
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      feature = {
        manyFiles = true;
      };
    };
    signing = {
      key = config.machine.gpgPubKey;
      signByDefault = true;
    };
    ignores = [
      "/bazel-*"
      "/.idea"
    ];
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
    font = {
      name = "monospace";
      size = 12;
    };
    settings = {
      include = pkgs.kitty-themes.mkKittyTheme "base16-material-darker";
    };
  };

  services.picom = {
    package = pkgs.picom-next;
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

  services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
