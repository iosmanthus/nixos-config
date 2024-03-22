{ config
, pkgs
, lib
, ...
}:
let
  modifier0 = "Mod4";
  modifier1 = "Mod1";
  betterlockscreen = "${pkgs.betterlockscreen}/bin/betterlockscreen";
  colors = config.scheme.withHashtag;
  i3 = {
    enable = true;
    package = pkgs.i3;
    config =
      {
        fonts =
          {
            names = [ "monospace" ];
            size = 12.0;
          };
        modifier = modifier0;
        focus = {
          newWindow = "focus";
        };
        window = {
          border = 0;
          titlebar = true;
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

          "${modifier0}+1" = "workspace 1: main";
          "${modifier0}+2" = "workspace 2: chat";
          "${modifier0}+3" = "workspace 3: mail";
          "${modifier0}+4" = "workspace 4: music";
          "${modifier0}+5" = "workspace 5: vm";

          "${modifier0}+Shift+1" = "move container to workspace 1: main";
          "${modifier0}+Shift+2" = "move container to workspace 2: chat";
          "${modifier0}+Shift+3" = "move container to workspace 3: mail";
          "${modifier0}+Shift+4" = "move container to workspace 4: music";
          "${modifier0}+Shift+5" = "move container to workspace 5: vm";

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
            exec ${betterlockscreen} -l dim
          '';
          "${modifier0}+c" = "exec env CM_LAUNCHER=rofi clipmenu";
          "${modifier0}+m" = "exec autorandr --change";
          "${modifier0}+w" = "exec brave";
          "${modifier0}+p" = "exec rofi -show combi";
          "${modifier0}+d" = "exec Discord";
          "${modifier0}+t" = "exec telegram-desktop";
          "${modifier0}+s" = "exec flameshot gui";
          "${modifier0}+n" = "exec dunstctl history-pop";
          "${modifier0}+Shift+n" = "exec dunstctl close-all";
          "${modifier0}+g" = "exec gedit";
          "${modifier0}+space" = "exec wmfocus";
          "${modifier0}+b" = "exec polybar-msg cmd toggle";

          # Disable tiling_drag before there is a threshold for it.
          "button1" = "focus";
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
        workspaceOutputAssign = [
          {
            workspace = "1: main";
            output = "primary";
          }
          {
            workspace = "2: chat";
            output = "primary";
          }
          {
            workspace = "3: mail";
            output = "primary";
          }
          {
            workspace = "4: music";
            output = "primary";
          }
          {
            workspace = "5: vm";
            output = "primary";
          }
        ];
        assigns = {
          "1: main" = [
            { class = "^Brave-browser$"; }
            { class = "^logseq$"; }
            { class = "^kitty$"; }
          ];
          "2: chat" = [
            { class = "^Discord$"; }
            { class = "^TelegramDesktop$"; }
          ];
          "3: mail" = [{ class = "^thunderbird$"; }];
          "4: music" = [{ class = "^Spotify$"; }];
          "5: vm" = [{ class = "^Remote-viewer$"; }];
        };
        startup = [
          {
            command = "fcitx5 -dr";
            always = true;
          }
          {
            command = "feh --bg-scale --conversion-timeout 1 ~/.background-image";
            always = true;
          }
          {
            command = "${betterlockscreen} -u ~/.background-image --fx dim,pixel";
            always = true;
          }
          {
            command = "systemctl restart --user polybar.service";
            always = true;
          }
          {
            command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            always = true;
          }
          {
            command = "i3-msg workspace 1: main";
          }
          {
            command = "brave";
          }
          {
            command = "logseq";
          }
          {
            command = "kitty tmux";
          }
          {
            command = "thunderbird";
          }
        ];
        bars = lib.mkForce [ ];
      };
    extraConfig = ''
      set $base00 ${colors.base00}
      set $base01 ${colors.base01}
      set $base02 ${colors.base02}
      set $base03 ${colors.base03}
      set $base04 ${colors.base04}
      set $base05 ${colors.base05}
      set $base06 ${colors.base06}
      set $base07 ${colors.base07}
      set $base08 ${colors.base08}
      set $base09 ${colors.base09}
      set $base0A ${colors.base0A}
      set $base0B ${colors.base0B}
      set $base0C ${colors.base0C}
      set $base0D ${colors.base0D}
      set $base0E ${colors.base0E}
      set $base0F ${colors.base0F}

      # Basic color configuration using the Base16 variables for windows and borders.
      # Property Name         Border  BG      Text    Indicator Child Border
      client.focused          $base03 $base02 $base07 $base0D $base0C
      client.focused_inactive $base00 $base01 $base07 $base03 $base01
      client.unfocused        $base01 $base00 $base05 $base01 $base01
      client.urgent           $base00 $base0A $base00 $base08 $base08
      client.placeholder      $base00 $base00 $base05 $base00 $base00
      client.background       $base07
    '';
  };
in
{
  xsession = {
    enable = true;
    windowManager = {
      inherit i3;
    };
  };
}
