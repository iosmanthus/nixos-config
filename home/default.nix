{ auto-fix-vscode-server, config, pkgs, ... }:
{
  imports = [
    ./shell
    ./xserver
    ./tmux.nix
    ./fusuma.nix
    ./vscode
  ];

  home.packages = with pkgs;[
    gh
    cloc
    tree
    ripgrep
    fd
    htop
    speedtest-cli
    ihaskell
    rustup
    joplin-desktop
    httpie
    nnn
    gnome.gnome-system-monitor
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
  ];

  home.keyboard.options = [ "caps:escape" ];

  programs.feh.enable = true;
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    font = "Dejavu Sans Mono 20";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      ssh-command = "{terminal} -- {terminal} +kitten ssh {host} [-p {port}]";
      show-icons = true;
      modi = "window,drun,ssh,combi";
      combi-modi = "window,drun,ssh";
      disable-history = false;
      sort = true;
      sorting-method = "fzf";
    };
  };

  programs.git = {
    enable = true;
    userName = "iosmanthus";
    userEmail = "myosmanthustree@gmail.com";
    extraConfig = {
      core = {
        editor = "${pkgs.vscode}/bin/code --wait";
      };
      pull = {
        rebase = false;
      };
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

  programs.kitty =
    let
      base16 = pkgs.callPackage ./base16-kitty.nix { };
    in
    {
      enable = true;
      font = {
        name = "Dejavu Sans Mono";
      };
      settings = {
        include = "${base16.mkKittyBase16Theme { name = "material-darker"; }}";
      };
    };

  programs.firefox = {
    enable = true;
    profiles.iosmanthus = {
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
