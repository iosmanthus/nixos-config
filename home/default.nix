{ config, pkgs, ... }:
{
  imports = [
    ./fusuma.nix
    ./tilix.nix
    ./shell
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
        editor = ''
          ${pkgs.vscode}/bin/code --wait
        '';
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

  programs.kitty = {
    enable = true;
    font = {
      name = "monospace";
    };
    extraConfig = ''
      background #282c34
      foreground #abb2bf
      selection_background #abb2bf
      selection_foreground #282c34
      url_color #565c64
      cursor #abb2bf
      active_border_color #545862
      inactive_border_color #353b45
      active_tab_background #282c34
      active_tab_foreground #abb2bf
      inactive_tab_background #353b45
      inactive_tab_foreground #565c64
      tab_bar_background #353b45

      # normal
      color0 #282c34
      color1 #e06c75
      color2 #98c379
      color3 #e5c07b
      color4 #61afef
      color5 #c678dd
      color6 #56b6c2
      color7 #abb2bf

      # bright
      color8 #545862
      color9 #e06c75
      color10 #98c379
      color11 #e5c07b
      color12 #61afef
      color13 #c678dd
      color14 #56b6c2
      color15 #c8ccd4

      # extended base16 colors
      color16 #d19a66
      color17 #be5046
      color18 #353b45
      color19 #3e4451
      color20 #565c64
      color21 #b6bdca
    '';
  };
}
