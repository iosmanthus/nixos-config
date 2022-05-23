{ ... }:
let
  name = "eDP-1";
  fingerprint = "00ffffffffffff004d109a1400000000041c0104a52213780ede50a3544c99260f505400000001010101010101010101010101010101ac3780a070383e403020350058c210000018000000000000000000000000000000000000000000fe004a30594b46804c513135364d31000000000002410328001200000a010a20200025";
in
{
  machine = {
    builtinDisplayPort = {
      inherit name fingerprint;
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
            mode = "1920x1080";
          };
        };
      };
    };
  };
}
