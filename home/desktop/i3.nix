{ pkgs
, lib
, ...
}:
let
  modifier0 = "Mod4";
  modifier1 = "Mod1";
in
{
  xsession.windowManager = {
    i3 = {
      enable = true;
      package = pkgs.i3;
      config =
        {
          fonts =
            {
              names = [ "Iosevka Nerd Font" ];
              size = 10.0;
            };
          modifier = modifier0;
          focus = {
            newWindow = "focus";
          };
          window = {
            border = 0;
            titlebar = false;
            commands = [
              {
                command = "title_window_icon on";
                criteria = {
                  all = true;
                };
              }
              {
                command = "resize set 640 480";
                criteria = {
                  window_role = "pop_up";
                };
              }
              {
                command = "resize set 640 480";
                criteria = {
                  window_role = "task_dialog";
                };
              }
              {
                command = "floating enable";
                criteria = {
                  window_role = "pop_up";
                };
              }
              {
                command = "floating enable";
                criteria = {
                  window_role = "task_dialog";
                };
              }
            ];
          };
          terminal = "kitty tmux";
          keybindings = lib.mkOptionDefault {
            "${modifier0}+Shift+c" = "kill";

            "${modifier1}+e" = "layout toggle split";
            "${modifier1}+h" = "split h";
            "${modifier1}+v" = "split v";
            "${modifier1}+s" = "layout stacking";
            "${modifier1}+w" = "layout tabbed";

            "${modifier0}+1" = "workspace 1: work";
            "${modifier0}+2" = "workspace 2: vm";
            "${modifier0}+3" = "workspace 3: chat";
            "${modifier0}+4" = "workspace 4: mail";
            "${modifier0}+5" = "workspace 5: music";

            "${modifier0}+Shift+1" = "move container to workspace 1: work";
            "${modifier0}+Shift+2" = "move container to workspace 2: vm";
            "${modifier0}+Shift+3" = "move container to workspace 3: chat";
            "${modifier0}+Shift+4" = "move container to workspace 4: mail";
            "${modifier0}+Shift+5" = "move container to workspace 5: music";

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
            "${modifier0}+Shift+x" = ''
              exec betterlockscreen -l dim
            '';
            "${modifier0}+c" = "exec env CM_LAUNCHER=rofi clipmenu";
            "${modifier0}+m" = "exec autorandr --change";
            "${modifier0}+w" = "exec firefox";
            "${modifier0}+p" = "exec rofi -show combi";
            "${modifier0}+d" = "exec Discord";
            "${modifier0}+t" = "exec telegram-desktop";
            "${modifier0}+s" = "exec flameshot gui";
            "${modifier0}+n" = "exec dunstctl history-pop";
            "${modifier0}+Shift+n" = "exec dunstctl close-all";
          };
          modes = lib.mkOptionDefault {
            resize = {
              j = "resize shrink height 10 px or 10 ppt";
              h = "resize shrink width 10 px or 10 ppt";
              l = "resize grow width 10 px or 10 ppt";
              k = "resize grow height 10 px or 10 ppt";
            };
          };
          workspaceAutoBackAndForth = true;
          workspaceLayout = "tabbed";
          assigns = {
            "1: work" = [{ class = "^firefox$"; }];
            "2: vm" = [{ class = "^Remote-viewer$"; }];
          };
          startup = [
            {
              command = "feh --bg-scale --conversion-timeout 1 ~/.background-image";
              always = true;
            }
            {
              command = "betterlockscreen -u ~/.background-image --fx dim,pixel";
              always = true;
            }
            {
              command = "i3-msg workspace 1: work";
            }
            {
              command = "systemctl restart --user polybar.service";
              always = true;
            }
            {
              command = "firefox";
            }
            {
              command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              always = true;
            }
          ];
          bars = lib.mkForce [ ];
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
        client.focused          $base00 $base03 $base07 $base0D $base0C
        client.focused_inactive $base01 $base01 $base07 $base03 $base01
        client.unfocused        $base01 $base00 $base05 $base01 $base01
        client.urgent           $base00 $base0A $base00 $base08 $base08
        client.placeholder      $base00 $base00 $base05 $base00 $base00
        client.background       $base07
      '';
    };
  };
}
