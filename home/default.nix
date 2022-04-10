{ config, pkgs, ... }: {
  imports = [
    ./shell
    ./xserver
    ./tmux.nix
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

  programs.kitty =
    let base16 = pkgs.callPackage ./base16-kitty.nix { };
    in
    {
      enable = true;
      font = { name = "Meslo LG M"; };
      settings = {
        include = "${base16.mkKittyBase16Theme { name = "material-darker"; }}";
      };
    };

  programs.firefox = {
    enable = true;
    profiles.${config.machine.userName} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"])
          #TabsToolbar
          > .toolbar-items {
          opacity: 0;
          pointer-events: none;
        }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
          visibility: collapse !important;
        }

        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          display: none;
        }

        #urlbar {
          font-size: 15pt !important;
        }
      '';
    };
  };
}
