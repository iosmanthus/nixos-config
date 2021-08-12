{ pkgs, ... }: {
  imports = [
    ./monitors.nix
  ];

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  programs.xmobar = {
    enable = true;
    extraConfig = ''
      Config
      { font = "xft:monospace:size=9:bold:antialias=true",
        additionalFonts = ["xft:Source Han Mono SC:size=9:bold:antialias=true"],
        bgColor = "#212121",
        fgColor = "#FFCB6B",
        position = Bottom,
        template = "<fn=1>%StdinReader%</fn> }{ | %wlp110s0% %wlp110s0wi% | %date% | %thermal1% | %battery%",
        commands =
          [ 
            Run Date "%a %b %_d %Y <fc=#ee9a00>%H:%M:%S</fc>" "date" 10,
            Run
              Network
              "wlp110s0"
              [ "-S",
                "True",
                "-t",
                "<dev>: up:<tx>/down:<rx>",
                "--Low",
                "1000000", -- units: B/s
                "--High",
                "5000000", -- units: B/s
                "--low",
                "darkgreen",
                "--normal",
                "darkorange",
                "--high",
                "darkred"
              ]
              10,
            Run
              Wireless
              "wlp110s0"
              ["-t", "<ssid>: <quality>"]
              10,
            Run BatteryP ["BAT1"] 
              ["-t", "<acstatus>"
                 , "-L", "10", "-H", "80"
                 , "-l", "red", "-h", "green"
                 , "--", "-O", "Charging", "-o", "Battery: <left>%"
                 ] 10,
            Run ThermalZone 1 ["-t","temp: <temp>"] 30,
            Run
              StdinReader
          ]
      }
    '';
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
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };
}
