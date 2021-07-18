{ pkgs, ... }: {
  #services.polybar = {
  #  enable = true;
  #  config = {
  #    "global/wm" = {
  #      margin-top = 0;
  #      margin-bottom = 0;
  #    };

  #    "bar/top" = {
  #      width = "100%";
  #      height = 48;
  #      radius = "6.0";
  #      fixed-center = true;
  #      modules-center = "date";
  #    };
  #    "module/date" = {
  #      date = "%Y-%m-%d%";
  #      type = "internal/date";
  #    };

  #    "module/xmonad" = {
  #      type = "custom/script";
  #      exec = "${pkgs.xmonad-log}/bin/xmonad-log";
  #      tail = true;
  #    };
  #  };
  #  script = "polybar top &";
  #};

  xresources.properties = {
    "Xft.dpi" = 192;
  };
  programs.autorandr = {
    enable = true;
    profiles = let

      eDP-1 =
        "00ffffffffffff0009e59c0800000000161d0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001a00000000000000000000000000000000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a01bf02030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
      externalOnly = {
        eDP-1.enable = false;
        DP-1 = {
          enable = true;
          primary = true;
          mode = "3840x2160";
          rate = "60.00";
        };
      };
    in
      {
        default = {
          fingerprint = {
            inherit eDP-1;
          };
          config = {
            eDP-1 = {
              enable = true;
              mode = "3840x2160";
            };
          };
        };
        home = {
          fingerprint = {
            inherit eDP-1;
            DP-1 =
              "00ffffffffffff0005e39027b4b90000141d0104b53c22783a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c010a2020202020200101020320f14b0103051404131f12021190230907078301000067030c0010001878565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e96005550210000184d6c80a070703e8030203a0055502100001a000000000028";
          };
          config = externalOnly;
        };
        office = {
          fingerprint = {
            inherit eDP-1;
            DP-1 =
              "00ffffffffffff004c2dcb0c43514d30081b0104b53d23783a5fb1a2574fa2280f5054bfef80714f810081c08180a9c0b300950001014dd000a0f0703e80302035005f592100001a000000fd00384b1e873c000a202020202020000000fc00553238453835300a2020202020000000ff004854504a3230303536310a2020010a02030ef041102309070783010000023a801871382d40582c45005f592100001e565e00a0a0a02950302035005f592100001a04740030f2705a80b0588a005f592100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000052";
          };
          config = externalOnly;
        };
      };
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
      extraPackages = hp: [
        hp.dbus
        hp.taffybar
      ];
    };
  };
}
