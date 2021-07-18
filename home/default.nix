{ auto-fix-vscode-server, config, pkgs, ... }:
{
  home.packages = with pkgs;[ gh htop speedtest-cli ihaskell rustup ];

  imports = [
    ./shell
    ./xserver
    ./fusuma.nix
    ./tilix.nix
    ./vscode.nix
    ./tmux.nix
  ];

  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    font = "monospace 20";
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

  services.fusuma = {
    enable = true;
    extraPackages = with pkgs;[ xdotool ];
    config = {
      threshold = {
        swipe = 0.1;
      };
      interval = {
        swipe = 0.7;
      };
      swipe = {
        "3" = {
          left = {
            # GNOME: Switch to left workspace
            command = "xdotool key ctrl+alt+Right";
          };
          right = {
            # GNOME: Switch to right workspace
            command = "xdotool key ctrl+alt+Left";
          };
          up = {
            # GNOME Activity
            command = "xdotool key super";
          };
          down = {
            # GNOME Activity
            command = "xdotool key super";
          };
        };
        "4" = {
          left = {
            # GNOME: Move window to right workspace
            command = "xdotool key ctrl+shift+alt+Right";
          };
          right = {
            # GNOME: Move window to left workspace
            command = "xdotool key ctrl+shift+alt+Left";
          };
          up = {
            # GNOME: Show all applications
            command = "xdotool key super+a";
          };
        };
      };
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
          name = "monospace";
        };
        settings = {
          include = "${base16.mkKittyBase16Theme { name = "material-darker"; }}";
        };
      };
}
