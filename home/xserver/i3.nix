{ pkgs, lib, ... }: {
  xsession.windowManager = {
    i3 = {
      enable = true;
      config =
        let
          modifier0 = "Mod4";
          modifier1 = "Mod1";
          wallpaper = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-blue.png";
            sha256 = "1llr175m454aqixxwbp3kb5qml2hi1kn7ia6lm7829ny6y7xrnms";
          };
        in
          {
            modifier = modifier0;
            terminal = "kitty tmux";
            keybindings =
              lib.mkOptionDefault {
                "${modifier0}+Shift+c" = "kill";

                "${modifier1}+e" = "layout toggle split";
                "${modifier1}+h" = "split h";
                "${modifier1}+v" = "split v";
                "${modifier1}+s" = "layout stacking";
                "${modifier1}+w" = "layout tabbed";

                "${modifier0}+1" = "workspace 1: work";
                "${modifier0}+2" = "workspace 2: vm";
                "${modifier0}+3" = "workspace 3: chat";
                "${modifier0}+4" = "workspace 4: misc";

                "${modifier0}+Shift+1" = "move container to workspace 1: work";
                "${modifier0}+Shift+2" = "move container to workspace 2: vm";
                "${modifier0}+Shift+3" = "move container to workspace 3: chat";
                "${modifier0}+Shift+4" = "move container to workspace 4: misc";

                "${modifier0}+j" = "focus down";
                "${modifier0}+h" = "focus left";
                "${modifier0}+l" = "focus right";
                "${modifier0}+k" = "focus up";
                "${modifier0}+x" = "[urgent=latest] focus";

                "${modifier0}+Tab" = "workspace next";
                "${modifier0}+Shift+Tab" = "workspace prev";

                "${modifier0}+Shift+j" = "move down";
                "${modifier0}+Shift+h" = "move left";
                "${modifier0}+Shift+l" = "move right";
                "${modifier0}+Shift+k" = "move up";

                "${modifier0}+Shift+q" = "exec i3-msg restart";
                "${modifier0}+Shift+x" = "exec ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
                "${modifier0}+c" = "exec env CM_LAUNCHER=rofi clipmenu";
                "${modifier0}+m" = "exec autorandr --change";
                "${modifier0}+w" = "exec firefox";
                "${modifier0}+p" = "exec rofi -show combi";
                "${modifier0}+d" = "exec Discord";
                "${modifier0}+t" = "exec telegram-desktop";
                "${modifier0}+s" = "exec flameshot gui";
              };
            modes = lib.mkOptionDefault {
              resize = {
                j = "resize grow height 10 px or 10 ppt";
                h = "resize shrink width 10 px or 10 ppt";
                l = "resize grow width 10 px or 10 ppt";
                k = "resize shrink height 10 px or 10 ppt";
              };
            };
            defaultWorkspace = "1: work";
            workspaceAutoBackAndForth = true;
            workspaceLayout = "tabbed";
            startup = [
              {
                command = "feh --bg-scale ${wallpaper}";
                always = true;
              }
              {
                command = "${pkgs.betterlockscreen}/bin/betterlockscreen -u ${wallpaper}";
                always = true;
              }
              {
                command = "systemctl restart --user polybar.service";
                always = true;
              }
              { command = "firefox"; }
            ];
            bars = [];
          };
      extraConfig = ''
        set $base00 #212121
        set $base01 #303030
        set $base02 #353535
        set $base03 #4A4A4A
        set $base04 #B2CCD6
        set $base05 #EEFFFF
        set $base06 #EEFFFF
        set $base07 #FFFFFF
        set $base08 #F07178
        set $base09 #F78C6C
        set $base0A #FFCB6B
        set $base0B #C3E88D
        set $base0C #89DDFF
        set $base0D #82AAFF
        set $base0E #C792EA
        set $base0F #FF5370

        # Basic color configuration using the Base16 variables for windows and borders.
        # Property Name         Border  BG      Text    Indicator Child Border
        client.focused          $base03 $base01 $base05 $base0D $base0C
        client.focused_inactive $base01 $base01 $base05 $base03 $base01
        client.unfocused        $base01 $base00 $base05 $base01 $base01
        client.urgent           $base08 $base08 $base00 $base08 $base08
        client.placeholder      $base00 $base00 $base05 $base00 $base00
        client.background       $base07
      '';
    };
  };
}
