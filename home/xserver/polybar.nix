{ pkgs, ... }:
{
  services.polybar =
    let
      base00 = "#212121";
      base01 = "#303030";
      base02 = "#353535";
      base03 = "#4A4A4A";
      base04 = "#B2CCD6";
      base05 = "#EEFFFF";
      base06 = "#EEFFFF";
      base07 = "#FFFFFF";
      base08 = "#F07178";
      base09 = "#F78C6C";
      base0A = "#FFCB6B";
      base0B = "#C3E88D";
      base0C = "#89DDFF";
      base0D = "#82AAFF";
      base0E = "#C792EA";
      base0F = "#FF5370";
    in
      {
        package = pkgs.polybar.override {
          mpdSupport = true;
          iwSupport = true;
          i3Support = true;
          i3GapsSupport = false;
          alsaSupport = true;
          pulseSupport = true;
          githubSupport = true;
        };
        enable = true;
        script = ''
          polybar main &
        '';
        extraConfig =
          let
            playerctl = "${pkgs.playerctl}/bin/playerctl";
            playerMprisSimple = pkgs.writeShellScript "player-mpris-simple" ''
              player_status=$(${playerctl} status 2> /dev/null)

              if [ "$player_status" = "Playing" ]; then
                  echo "Playing $(${playerctl} metadata artist) - $(${playerctl} metadata title)"
              elif [ "$player_status" = "Paused" ]; then
                  echo "Paused $(${playerctl} metadata artist) - $(${playerctl} metadata title)"
              else
                  echo "No Track"
              fi

            '';
          in
            ''
              [colors]
              ;background = ''${xrdb:color0:#222}
              background = #222
              background-alt = #444
              ;foreground = ''${xrdb:color7:#222}
              foreground = #dfdfdf
              foreground-alt = #555
              primary = #ffb52a
              secondary = #e60053
              alert = #bd2c40

              [bar/main]
              ;monitor = ''${env:MONITOR:HDMI-1}
              width = 100%
              height = 48
              ;offset-x = 1%
              ;offset-y = 1%
              radius = 6.0
              fixed-center = false

              background = ''${colors.background}
              foreground = ''${colors.foreground}

              line-size = 3
              line-color = #f00

              border-size = 4
              border-color = #00000000

              padding-left = 0
              padding-right = 2
              bottom = true

              module-margin-left = 1
              module-margin-right = 2

              font-0 = monospace:pixelsize=18;1
              font-1 = Microsoft YaHei:pixelsize=18
              font-2 = unifont:fontformat=truetype:pixelsize=18:antialias=true;0
              font-3 = siji:pixelsize=18;1
              font-4 = NotoEmoji:scale=5;1

              modules-left = i3 xwindow
              modules-center = 
              modules-right = player-mpris-simple backlight pulseaudio memory cpu wlan battery temperature date

              tray-position = right
              tray-padding = 2
              tray-maxsize = 64
              ;tray-background = #0063ff

              ;wm-restack = bspwm
              ;wm-restack = i3

              ;override-redirect = true

              ;scroll-up = bspwm-desknext
              ;scroll-down = bspwm-deskprev

              ;scroll-up = i3wm-wsnext
              ;scroll-down = i3wm-wsprev

              cursor-click = pointer
              cursor-scroll = ns-resize

              [module/xwindow]
              type = internal/xwindow
              label = %title:0:30:...%

              [module/filesystem]
              type = internal/fs
              interval = 25

              mount-0 = /

              label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
              label-unmounted = %mountpoint% not mounted
              label-unmounted-foreground = ''${colors.foreground-alt}

              ; Separator in between workspaces
              ; label-separator = |

              [module/i3]
              type = internal/i3
              format = <label-state> <label-mode>
              index-sort = true
              wrapping-scroll = false

              ; Only show workspaces on the same output as the bar
              ;pin-workspaces = true

              label-mode-padding = 2
              label-mode-foreground = #000
              label-mode-background = ''${colors.primary}

              ; focused = Active workspace on focused monitor
              label-focused = %name%
              label-focused-background = ''${colors.background-alt}
              label-focused-underline= ''${colors.primary}
              label-focused-padding = 2

              ; unfocused = Inactive workspace on any monitor
              label-unfocused = %name%
              label-unfocused-padding = 2

              ; visible = Active workspace on unfocused monitor
              label-visible = %index%
              label-visible-background = ''${self.label-focused-background}
              label-visible-underline = ''${self.label-focused-underline}
              label-visible-padding = ''${self.label-focused-padding}

              ; urgent = Workspace with urgency hint set
              label-urgent = %name%
              label-urgent-background = ''${colors.alert}
              label-urgent-padding = 2

              ; Separator in between workspaces
              ; label-separator = |


              [module/backlight]
              type = internal/backlight
              card = intel_backlight
              enable-scroll = true

              [module/cpu]
              type = internal/cpu
              interval = 2
              format-prefix = " "
              format-prefix-foreground = ''${colors.foreground-alt}
              format-underline = #f90000
              label = %percentage:2%%

              [module/memory]
              type = internal/memory
              interval = 2
              format-prefix = " "
              format-prefix-foreground = ''${colors.foreground-alt}
              format-underline = #4bffdc
              label = %percentage_used%%

              [module/wlan]
              type = internal/network
              interface = wlp110s0
              interval = 1.0
              ping-interval = 3

              format-connected = <ramp-signal> <label-connected>
              format-connected-underline = #9f78e1
              label-connected = %essid% %signal%% %upspeed:4% %downspeed:4%

              format-disconnected =
              ;format-disconnected = <label-disconnected>
              ;format-disconnected-underline = ''${self.format-connected-underline}
              ;label-disconnected = %ifname% disconnected
              ;label-disconnected-foreground = ''${colors.foreground-alt}

              ramp-signal-0 = 
              ramp-signal-1 = 
              ramp-signal-2 = 
              ramp-signal-3 = 
              ramp-signal-4 = 
              ramp-signal-foreground = ''${colors.foreground-alt}

              [module/date]
              type = internal/date
              interval = 5

              date = " %Y-%m-%d"
              time = %H:%M:%S

              format-prefix = 
              format-prefix-foreground = ''${colors.foreground-alt}
              format-underline = #0a6cf5

              label = %date% %time%

              [module/pulseaudio]
              type = internal/pulseaudio

              format-volume = <label-volume> <bar-volume>
              label-volume = VOL %percentage%%
              label-volume-foreground = ''${root.foreground}

              label-muted = 🔇 muted
              label-muted-foreground = #666

              bar-volume-width = 10
              bar-volume-foreground-0 = #55aa55
              bar-volume-foreground-1 = #55aa55
              bar-volume-foreground-2 = #55aa55
              bar-volume-foreground-3 = #55aa55
              bar-volume-foreground-4 = #55aa55
              bar-volume-foreground-5 = #f5a70a
              bar-volume-foreground-6 = #ff5555
              bar-volume-gradient = false
              bar-volume-indicator = |
              bar-volume-indicator-font = 2
              bar-volume-fill = ─
              bar-volume-fill-font = 2
              bar-volume-empty = ─
              bar-volume-empty-font = 2
              bar-volume-empty-foreground = ''${colors.foreground-alt}

              [module/battery]
              type = internal/battery
              battery = BAT1
              adapter = ADP1
              full-at = 98

              format-charging = <animation-charging> <label-charging>
              format-charging-underline = #ffb52a

              format-discharging = <animation-discharging> <label-discharging>
              format-discharging-underline = ''${self.format-charging-underline}

              format-full-prefix = " "
              format-full-prefix-foreground = ''${colors.foreground-alt}
              format-full-underline = ''${self.format-charging-underline}

              ramp-capacity-0 = 
              ramp-capacity-1 = 
              ramp-capacity-2 = 
              ramp-capacity-foreground = ''${colors.foreground-alt}

              animation-charging-0 = 
              animation-charging-1 = 
              animation-charging-2 = 
              animation-charging-foreground = ''${colors.foreground-alt}
              animation-charging-framerate = 750

              animation-discharging-0 = 
              animation-discharging-1 = 
              animation-discharging-2 = 
              animation-discharging-foreground = ''${colors.foreground-alt}
              animation-discharging-framerate = 750

              [module/temperature]
              type = internal/temperature
              interval = 5
              thermal-zone = 0
              warn-temperature = 50
              hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input

              format = <ramp> <label>
              format-underline = #f50a4d
              format-warn = <ramp> <label-warn>
              format-warn-underline = ''${self.format-underline}

              label = %temperature-c%
              ramp-0 = 
              ramp-1 = 
              ramp-2 = 
              ramp-foreground = ''${colors.foreground-alt}

              [module/powermenu]
              type = custom/menu

              expand-right = true

              format-spacing = 1

              label-open = 
              label-open-foreground = ''${colors.secondary}
              label-close =  cancel
              label-close-foreground = ''${colors.secondary}
              label-separator = |
              label-separator-foreground = ''${colors.foreground-alt}

              menu-0-0 = reboot
              menu-0-0-exec = menu-open-1
              menu-0-1 = power off
              menu-0-1-exec = menu-open-2

              menu-1-0 = cancel
              menu-1-0-exec = menu-open-0
              menu-1-1 = reboot
              menu-1-1-exec = sudo reboot

              menu-2-0 = power off
              menu-2-0-exec = sudo poweroff
              menu-2-1 = cancel
              menu-2-1-exec = menu-open-0

              [settings]
              screenchange-reload = true
              ;compositing-background = xor
              ;compositing-background = screen
              ;compositing-foreground = source
              ;compositing-border = over
              ;pseudo-transparency = false

              [global/wm]
              margin-top = 5
              margin-bottom = 5

              [module/player-mpris-simple]
              type = custom/script
              exec = ${playerMprisSimple}
              interval = 1
              click-left = ${playerctl} previous &
              click-right = ${playerctl} next &
              click-middle = ${playerctl} play-pause &
            '';
      };
}
