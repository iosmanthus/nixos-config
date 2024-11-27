{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../base/firefox
    ../base/shell
    ../base/tmux

    ./desktop
    ./fcitx5
    ./gpg
    ./neovim
    ./polybar
    ./rofi
    ./vscode
  ];

  sops.age.keyFile = "${config.admin.home}/.config/sops/age/keys.txt";

  home.stateVersion = "18.09";

  home.packages =
    with pkgs;
    [
      ascii
      awscli2
      brave
      btop
      delta
      delve
      discord
      fast-cli
      fd
      feishu
      flameshot
      flyctl
      follow
      fzf
      gedit
      geoipWithDatabase
      gh
      gnome-clocks
      gnome-font-viewer
      go-musicfox
      go-tools
      google-cloud-sdk
      graphviz
      htop
      httpie
      imagemagick
      iperf3
      jq
      k9s
      kubectl
      kubectx
      kubernetes-helm
      libnotify
      logseq
      mariadb
      minikube
      mycli
      nix-output-monitor
      nnn
      nur.repos.linyinfeng.wemeet
      openai-translator
      pavucontrol
      peek
      pgcli
      quickemu
      regctl
      ripgrep
      seahorse
      slack
      solaar
      sops
      speedtest-cli
      spotify-unwrapped
      ssm-session-manager-plugin
      tdesktop
      thunderbird
      tldr
      tokei
      tor
      tree
      unzip
      via
      vlc
      wireguard-tools
      wmfocus
      xfce.xfce4-taskmanager
      xxd
      zoom-us
      wechat-uos
      (retroarch.override {
        cores = with pkgs.libretro; [
          mgba
          melonds
        ];
      })
    ]
    ++ (
      let
        commonPlugins = [
          "github-copilot"
          "ideavim"
        ];
      in
      # https://github.com/NixOS/nixpkgs/pull/223593
      with pkgs.jetbrains;
      [
        (plugins.addPlugins clion commonPlugins)
        (plugins.addPlugins goland commonPlugins)
        (plugins.addPlugins idea-ultimate commonPlugins)
        (plugins.addPlugins pycharm-professional commonPlugins)
        (plugins.addPlugins rust-rover commonPlugins)
        (plugins.addPlugins webstorm commonPlugins)
      ]
    );

  home.sessionVariables = {
    "TERMINAL" = "${pkgs.kitty}/bin/kitty";
  };

  home.activation = {
    createGoPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p $VERBOSE_ARG $HOME/.go
    '';
  };

  home.keyboard.options = [ "caps:escape" ];

  programs.feh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = config.admin.name;
    userEmail = config.admin.email;
    extraConfig = {
      core = {
        editor = "${pkgs.vscode-launcher} --wait";
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
    };
    signing = {
      key = config.admin.gpgPubKey;
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

  programs.gpg = {
    enable = true;
  };

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

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.blueman-applet.enable = true;

  services.network-manager-applet.enable = true;

  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      keymap_mode = "vim-normal";
      search_mode = "fuzzy";
      style = "compact";
      sync_address = "https://atuin.iosmanthus.com";
      sync_frequency = "10m";
    };
  };

  services.mpris-proxy.enable = true;

  services.playerctld.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        contrastOpacity = 180;
        disabledTrayIcon = true;
        filenamePattern = "Screenshot-%F-%H-%M-%S";
        savePathFixed = true;
        showDesktopNotification = true;
        showHelp = false;
        startupLaunch = false;
      };
    };
  };
}
