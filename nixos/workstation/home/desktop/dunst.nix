{ config, pkgs, ... }:
let
  playNotificationSound = pkgs.writeShellScript "play-notification-sound" ''
    ${pkgs.mpv}/bin/mpv ${pkgs.yaru-theme}/share/sounds/Yaru/stereo/message.oga
  '';
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = rec {
        font = "monospace 10";
        origin = "bottom-right";
        line_height = 5;
        width = 300;
        height = 500;
        progress_bar = true;
        markup = "full";
        format = "<i>%a</i>\\n<b>%s</b>\\n%b";
        frame_color = "${config.scheme.withHashtag.base03}";
        separator_color = frame_color;
      };

      base16_low = {
        msg_urgency = "low";
        background = "${config.scheme.withHashtag.base00}";
        foreground = "${config.scheme.withHashtag.base05}";
      };

      base16_normal = {
        msg_urgency = "normal";
        background = "${config.scheme.withHashtag.base00}";
        foreground = "${config.scheme.withHashtag.base05}";
      };

      base16_critical = {
        msg_urgency = "critical";
        background = "${config.scheme.withHashtag.base08}";
        foreground = "${config.scheme.withHashtag.base05}";
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
