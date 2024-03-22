{ config
, pkgs
, ...
}:

let
  playerctl = import ./playerctl.nix { inherit pkgs; };
  iw = "${pkgs.iw}/bin/iw";
  awk = "${pkgs.gawk}/bin/awk";
  ls = "${pkgs.coreutils}/bin/ls";
  grep = "${pkgs.gnugrep}/bin/grep";
  colors = config.scheme.withHashtag;
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      iwSupport = true;
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
      githubSupport = true;
    };
    script = ''
      export COLOR_BASE00=${colors.base00}
      export COLOR_BASE01=${colors.base01}
      export COLOR_BASE02=${colors.base02}
      export COLOR_BASE03=${colors.base03}
      export COLOR_BASE04=${colors.base04}
      export COLOR_BASE05=${colors.base05}
      export COLOR_BASE06=${colors.base06}
      export COLOR_BASE07=${colors.base07}
      export COLOR_BASE08=${colors.base08}
      export COLOR_BASE09=${colors.base09}
      export COLOR_BASE0A=${colors.base0A}
      export COLOR_BASE0B=${colors.base0B}
      export COLOR_BASE0C=${colors.base0C}
      export COLOR_BASE0D=${colors.base0D}
      export COLOR_BASE0E=${colors.base0E}
      export COLOR_BASE0F=${colors.base0F}

      export NETWORK_LABEL_CONNECTED="%essid% %{F$COLOR_BASE0B}%upspeed%%{F-} %{F$COLOR_BASE0A}%downspeed%%{F-} %{F$COLOR_BASE0E}%signal%%%{F-}"
      export DATE_LABEL="🕓 %date% %{F$COLOR_BASE0C}%time%%{F-}"
      export HWMON_PATH=$(echo /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input)
      export ADAPTER=$(${ls} -1 /sys/class/power_supply | ${grep} AC)
      export BATTERY=$(${ls} -1 /sys/class/power_supply | ${grep} BAT)

      export WIFI_DEVICE=$(${iw} dev | ${awk} '$1=="Interface"{print $2}')
      polybar main &
    '';
    extraConfig = ''
      ${playerctl}

      [colors]
      base00=${colors.base00}
      base01=${colors.base01}
      base02=${colors.base02}
      base03=${colors.base03}
      base04=${colors.base04}
      base05=${colors.base05}
      base06=${colors.base06}
      base07=${colors.base07}
      base08=${colors.base08}
      base09=${colors.base09}
      base0A=${colors.base0A}
      base0B=${colors.base0B}
      base0C=${colors.base0C}
      base0D=${colors.base0D}
      base0E=${colors.base0E}
      base0F=${colors.base0F}

      [bar/main]
      width = 100%
      height = 80
      radius = 0.0
      override-redirect = false
      wm-restack = i3
      fixed-center = true
      bottom = true
      line-size = 6
      enable-ipc = true

      background=''${colors.base00}
      foreground=''${colors.base07}

      modules-left = i3 sep playerctl
      modules-center =
      modules-right = temperature sep cpu sep memory sep network sep backlight sep date sep pulseaudio sep battery sep tray

      font-0 = "monospace:size=20;3"
      font-1 = "Material\-Design\-Iconic\-Font:size=20;3"
      font-2 = "NotoEmoji:scale=5;3"
      font-3 = "feather:size=20;3"
      font-4 = "Microsoft YaHei:size=20;3"

      dpi-x = 96
      dpi-y = 96

      [module/tray]
      type = internal/tray
      tray-maxsize = 12
      tray-spacing = 2
      tray-padding = 2

      [module/date]
      type = internal/date

      ; Seconds to sleep between updates
      interval = 1.0

      ; See "https://en.cppreference.com/w/cpp/io/manip/put_time" for details on how to format the date string
      ; NOTE: if you want to use syntax tags here you need to use %%{...}
      date = %Y-%m-%d%

      ; Optional time format
      time = %H:%M

      ; if `date-alt` or `time-alt` is defined, clicking
      ; the module will toggle between formats
      date-alt = %A, %d %B %Y
      time-alt = %H:%M:%S
      format = <label>
      label = ''${env:DATE_LABEL}

      [module/backlight]
      type = internal/backlight
      card = intel_backlight
      enable-scroll = true
      use-actual-brightness = true
      format = <ramp>
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

      ws-icon-0 = main;
      ws-icon-1 = chat;
      ws-icon-2 = mail;
      ws-icon-3 = music;
      ws-icon-4 = vm;
      ws-icon-default = 

      format = <label-state> <label-mode>

      label-mode = %mode%
      label-mode-padding = 2
      label-mode-background = ''${colors.base0D}

      label-focused = %index% %icon%
      label-focused-foreground = ''${colors.base07}
      label-focused-background = ''${colors.base03}
      label-focused-underline = ''${colors.base0E}
      label-focused-padding = 1

      label-unfocused = %index% %icon%
      label-unfocused-padding = 1

      label-visible = %index% %icon%
      label-visible-padding = 1

      label-urgent = %index% %icon%
      label-urgent-foreground = ''${colors.base00}
      label-urgent-background = ''${colors.base0F}
      label-urgent-padding = 1

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
