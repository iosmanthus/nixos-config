{ pkgs, ... }:

let
  playerMprisSimpleModule = (import ./mpris.nix { inherit pkgs; });
  iw = "${pkgs.iw}/bin/iw";
  awk = "${pkgs.gawk}/bin/awk";
  ls = "${pkgs.coreutils}/bin/ls";
  grep = "${pkgs.gnugrep}/bin/grep";
in
{
  services.polybar = {
    package = pkgs.polybar.override {
      mpdSupport = true;
      iwSupport = true;
      i3Support = true;
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      githubSupport = true;
    };
    enable = true;
    script = ''
      export COLOR_BASE00=#212121
      export COLOR_BASE01=#303030
      export COLOR_BASE02=#353535
      export COLOR_BASE03=#4A4A4A
      export COLOR_BASE04=#B2CCD6
      export COLOR_BASE05=#EEFFFF
      export COLOR_BASE06=#EEFFFF
      export COLOR_BASE07=#FFFFFF
      export COLOR_BASE08=#F07178
      export COLOR_BASE09=#F78C6C
      export COLOR_BASE0A=#FFCB6B
      export COLOR_BASE0B=#C3E88D
      export COLOR_BASE0C=#89DDFF
      export COLOR_BASE0D=#82AAFF
      export COLOR_BASE0E=#C792EA
      export COLOR_BASE0F=#FF5370

      export NETWORK_LABEL_CONNECTED="%{u$COLOR_BASE0C}%{+u} %essid% %{-u} %{u$COLOR_BASE0D}%{+u} %{F$COLOR_BASE0B}%upspeed%%{F-} %{F$COLOR_BASE0A}%downspeed%%{F-} %{-u}"
      export DATE_LABEL="%{u$COLOR_BASE0E}%{+u}%date% %time%%{-u}"
      export HWMON_PATH=$(echo /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input)
      export ADAPTER=$(${ls} -1 /sys/class/power_supply | ${grep} AC)
      export BATTERY=$(${ls} -1 /sys/class/power_supply | ${grep} BAT)

      export WIFI_DEVICE=$(${iw} dev | ${awk} '$1=="Interface"{print $2}')
      polybar main &
    '';
    extraConfig = ''
      ${playerMprisSimpleModule}

      [colors]
      base00=#212121
      base01=#303030
      base02=#353535
      base03=#4A4A4A
      base04=#B2CCD6
      base05=#EEFFFF
      base06=#EEFFFF
      base07=#FFFFFF
      base08=#F07178
      base09=#F78C6C
      base0A=#FFCB6B
      base0B=#C3E88D
      base0C=#89DDFF
      base0D=#82AAFF
      base0E=#C792EA
      base0F=#FF5370

      [bar/main]
      width = 100%
      height = 36
      radius = 0.0
      override-redirect = false
      wm-restack = i3
      fixed-center = true
      bottom = true
      line-size = 4

      background=''${colors.base00}
      foreground=''${colors.base07}

      modules-left = i3 sep player-mpris-simple
      modules-center =
      modules-right = sep temperature sep cpu sep memory sep network sep backlight sep date sep pulseaudio sep battery sep

      font-0 = "Dejavu Sans Mono:size=18;3"
      font-1 = "Material\-Design\-Iconic\-Font:size=18;3"
      font-2 = "NotoEmoji:scale=5;3"
      font-3 = "feather:size=18;3"
      font-4 = "Microsoft YaHei:size=18;3"

      tray-position = right
      tray-detached = false
      tray-maxsize = 48
      tray-background = ''${root.background}
      tray-offset-x = 0
      tray-offset-y = 0
      tray-padding = 0
      tray-scale = 1.0

      dpi-x = 96
      dpi-y = 96

      [module/date]
      type = internal/date

      ; Seconds to sleep between updates
      interval = 1.0
      time = " %H:%M:%S"
      date = " %A, %d %b %Y"
      format = <label>
      label = ''${env:DATE_LABEL}

      [module/backlight]
      type = internal/backlight
      card = intel_backlight
      enable-scroll = true
      use-actual-brightness = true
      format = <ramp> <label>
      label = %percentage%%
      ramp-0 = 
      ramp-1 = 
      ramp-2 = 
      ramp-3 = 
      ramp-4 = 

      [module/memory]
      type = internal/memory
      interval = 1
      format = <label>
      format-prefix = 
      label = " %gb_used%/%percentage_used%%"
        
      [module/cpu]
      type = internal/cpu
      interval = 5
      format = <label>
      format-prefix = 
      label = " %percentage%%"

      [module/temperature]
      type = internal/temperature
      interval = 5
      hwmon-path = ''${env:HWMON_PATH}
      warn-temperature = 70
      units = true

      format = <ramp> <label>
      format-warn = <ramp> <label-warn>
      label = %temperature-c%
      label-warn = "%temperature-c%"
      label-warn-foreground = ''${colors.base0A}
      ramp-0 = 
      ramp-1 = 
      ramp-2 = 
      ramp-3 = 
      ramp-4 = 

      [module/battery]
      type = internal/battery
      full-at = 97
      battery = ''${env:BATTERY}
      adapter = ''${env:ADAPTER}
      poll-interval = 5

      time-format = %H:%M
      format-charging = <animation-charging> <label-charging>
      format-discharging = <ramp-capacity> <label-discharging>
      format-full = <label-full>
      format-full-prefix = 
      label-charging = %percentage%%
      label-discharging = %percentage%%
      label-full = " Full"

      ramp-capacity-0 = 
      ramp-capacity-1 = 
      ramp-capacity-2 = 
      ramp-capacity-3 = 
      ramp-capacity-4 = 
      ramp-capacity-5 = 
      ramp-capacity-6 = 
      ramp-capacity-7 = 
      ramp-capacity-8 = 
      ramp-capacity-9 = 

      animation-charging-0 = 
      animation-charging-1 = 
      animation-charging-framerate = 750


      [module/network]
      type = internal/network
      interface = ''${env:WIFI_DEVICE}

      interval = 2.0
      accumulate-stats = false
      unknown-as-up = true

      format-connected = <ramp-signal> <label-connected>
      format-disconnected = <label-disconnected>
      format-disconnected-prefix = 
      label-connected = ''${env:NETWORK_LABEL_CONNECTED}
      label-disconnected = "Offline"
      ramp-signal-0 = 
      ramp-signal-1 = 
      ramp-signal-2 = 

      [module/pulseaudio]
      type = internal/pulseaudio
      use-ui-max = true
      interval = 5

      format-volume = <ramp-volume> <label-volume>
      format-muted = <label-muted>
      format-muted-prefix = 
      label-volume = %percentage%%
      label-muted = " Muted"
      label-muted-foreground = ''${colors.base0F}
      ramp-volume-0 = 
      ramp-volume-1 = 
      ramp-volume-2 = 

      [module/i3]
      type = internal/i3
      pin-workspaces = false
      strip-wsnumbers = true
      index-sort = true
      enable-click = true
      enable-scroll = true
      wrapping-scroll = true
      reverse-scroll = false
      fuzzy-match = true

      ws-icon-0 = 1;
      ws-icon-1 = 2;
      ws-icon-2 = 3;
      ws-icon-3 = 4;
      ws-icon-4 = 5;
      ws-icon-default = 

      format = <label-state> <label-mode>

      label-mode = %mode%
      label-mode-padding = 2
      label-mode-background = ''${colors.base0D}

      label-focused = %icon% %name%
      label-focused-foreground = ''${colors.base07}
      label-focused-background = ''${colors.base03}
      label-focused-underline = ''${colors.base0E}
      label-focused-padding = 2

      label-unfocused = %icon% %name%
      label-unfocused-padding = 2

      label-visible = %icon% %name%
      label-visible-padding = 2

      label-urgent = %icon% %name%
      label-urgent-foreground = ''${colors.base00}
      label-urgent-background = ''${colors.base0F}
      label-urgent-padding = 2

      ; Separator in between workspaces
      label-separator = |
      label-separator-padding = 1
      label-separator-foreground = ''${colors.base03}

      [module/sep]
      type = custom/text
      content = |
      content-padding = 1

      content-foreground = ''${colors.base02}
    '';
  };
}
