{ config, ... }:
let
  name = "eDP-1-1";
  fingerprint = "00ffffffffffff004d10d61400000000051e0104b52517780a0dc2a95533ba240d50570000000101010101010101010101010101010172e700a0f0604590302036006ee51000001828b900a0f0604590302036006ee510000018000000fe00374a584b38814c513137305231000000000002410332011200000b010a2020014702030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
in
{
  machine = {
    displayPorts = {
      builtin = {
        inherit name fingerprint;
      };
      extra = builtins.map (p: "DP-1-" + (builtins.toString p)) [ 1 2 3 4 ];
    };
  };
  services.autorandr = {
    enable = true;
    profiles = {
      default = {
        fingerprint = {
          "${name}" = fingerprint;
        };
        config = {
          "${name}" = {
            enable = true;
            mode = "3840x2400";
          };
        };
      };

      home-dual-1-2 = {
        fingerprint = {
          "${name}" = fingerprint;
          "DP-1-1" = config.monitors.home-lg.fingerprint;
          "DP-1-2" = config.monitors.home-aoc.fingerprint;
        };
        config = {
          "${name}".enable = false;
          "DP-1-2" = {
            enable = true;
            primary = true;
            position = "3840x0";
            mode = "3840x2160";
            rate = "60.00";
          };
          "DP-1-1" = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "2560x1440";
            rate = "60.00";
            rotate = "left";
          };
        };
      };
    };
  };
}
