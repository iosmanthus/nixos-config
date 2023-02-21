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
    awscli2
    bazel_6
    btop
    cloc
    delve
    discord
    fd
    flameshot
    geoipWithDatabase
    gh
    gnome.gedit
    gnome.gnome-clocks
    gnome.gnome-font-viewer
    gnome.seahorse
    go-tools
    google-chrome
    htop
    httpie
    imagemagick
    iperf3
    jq
    kubectl
    libnotify
    logseq
    mariadb
    mycli
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
    vlc
    wireguard-tools
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

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "text/plain" = "vscode.desktop";
        "text/*" = "vscode.desktop";
      };
    };
  };

  programs.feh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    inherit (config.machine) userName userEmail;
    extraConfig = {
      core = { editor = "${pkgs.runVscode} --wait"; };
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

  services.blueman-applet.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
