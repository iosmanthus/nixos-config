{ config, pkgs, lib, ... }: {
  imports = [
    ./monitors.nix
    ./polybar.nix
  ];

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  services.mpd.enable = true;
  services.mpris-proxy.enable = true;
  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
    notifications = true;
  };

  xsession = {
    profileExtra = ''
      eval $(${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
      export SSH_AUTH_SOCK
    '';
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 48;
    };
    enable = true;
    windowManager = {
      i3 = {
        enable = true;
        config =
          let
            modifier0 = "Mod4";
            modifier1 = "Mod1";
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

                  "${modifier0}+Shift+1" = "move container to workspace number 1";
                  "${modifier0}+Shift+2" = "move container to workspace number 2";
                  "${modifier0}+Shift+3" = "move container to workspace number 3";
                  "${modifier0}+Shift+4" = "move container to workspace number 4";

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
                  command = "fcitx5 -d";
                  notification = true;
                }
                {
                  command = "systemctl restart --user polybar.service";
                  always = true;
                  notification = true;
                }
                { command = "firefox"; }
              ];
              bars = [];
            };
      };
    };
  };
}
