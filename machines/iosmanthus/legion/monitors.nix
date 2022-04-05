{ config, ... }:
let
  fingerprint =
    "00ffffffffffff0009e59c0800000000161d0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001a00000000000000000000000000000000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a01bf02030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
in
{
  services.autorandr = {
    enable = true;
    profiles = {
      default = {
        fingerprint = {
          "${config.machine.displayPort}" = fingerprint;
        };
        config = {
          "${config.machine.displayPort}" = {
            enable = true;
            mode = "3840x2160";
          };
        };
      };
    };
  };
}
