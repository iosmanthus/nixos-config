{ auto-fix-vscode-server, config, pkgs, ... }:
{
  imports = [
    ./shell
    ./xserver
    ./vscode.nix
    ./tmux.nix
    #./fusuma.nix
  ];

  home.packages = with pkgs;[
    gh
    cloc
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

    iperf3
    yesplaymusic
    flameshot
    thunderbird
    zoom-us
    firefox-bin
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
      base16 = pkgs.callPackage ./base16-kitty.nix {};
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
}
