{ pkgs
, ...
}:
let
  playNotificationSound = pkgs.writeShellScript "play-notification-sound" ''
    ${pkgs.mpv}/bin/mpv ${pkgs.yaru-theme}/share/sounds/Yaru/stereo/message.oga
  '';
in
{
  # Fix notification disappeared.
  systemd.user = {
    services = {
      restart-dunst = {
        Unit = {
          Description = "Restart dunst";
          Requires = "dunst.service";
          After = "dunst.service";
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl restart --user dunst.service";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };

    timers = {
      restart-dunst = {
        Unit = {
          Description = "Timer for restart-dunst";
        };

        Timer = {
          AccuracySec = "1s";
          OnUnitActiveSec = "1h";
        };

        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "monospace 10";
        origin = "bottom-right";
        line_height = 5;
        width = 300;
        height = 500;
        progress_bar = true;
        markup = "full";
        format = "<i>%a</i>\\n<b>%s</b>\\n%b";
        frame_color = "#EEFFFF";
        separator_color = "#EEFFFF";
      };

      base16_low = {
        msg_urgency = "low";
        background = "#353535";
        foreground = "#EEFFFF";
      };

      base16_normal = {
        msg_urgency = "normal";
        background = "#353535";
        foreground = "#EEFFFF";
      };

      base16_critical = {
        msg_urgency = "critical";
        background = "#F07178";
        foreground = "#EEFFFF";
      };

      play_sound = {
        summary = "*";
        script = "${playNotificationSound}";
      };
    };

    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
      size = "32x32";
    };
  };
}
