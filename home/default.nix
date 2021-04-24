{ config, pkgs, ... }:
{
  imports = [
    ./fusuma.nix
  ];

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
        editor = ''"${pkgs.vscode}/bin/code" --wait'';
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

}
