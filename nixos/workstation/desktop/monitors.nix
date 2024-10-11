{ config, pkgs, ... }:
let
  builtin = config.monitors.builtin.name;
  builtinFp = config.monitors.builtin.fingerprint;
  externalMonitors = config.monitors.external;
  inherit (config.monitors.builtin) ports;
  restartPolybar = ''
    systemctl=${pkgs.systemd}/bin/systemctl
    if $systemctl --user list-unit-files | grep -q polybar.service; then
      $systemctl restart --user polybar.service
    fi
  '';
  hooks = {
    postswitch = {
      inherit restartPolybar;
    };
  };
  mk4k = p: {
    "${builtin}".enable = false;
    "${p}" = {
      enable = true;
      primary = true;
      mode = "3840x2160";
      rate = "60.00";
    };
  };
  mkProfile =
    {
      name,
      fingerprint,
      mkConfig,
      ports,
    }:
    builtins.foldl' (
      profile: port:
      profile
      // {
        "${name}-${port}" = {
          fingerprint = {
            "${builtin}" = builtinFp;
            "${port}" = fingerprint;
          };
          config = mkConfig port;
          inherit hooks;
        };
      }
    ) { } ports;
in
{
  monitors = {
    external = {
      home-aoc.fingerprint = "00ffffffffffff0005e39027b4b90000141d0104b53c22783a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c010a2020202020200101020320f14b0103051404131f12021190230907078301000067030c0010001878565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e96005550210000184d6c80a070703e8030203a0055502100001a000000000028";
      #office-lg.fingerprint = "00ffffffffffff004c2dcb0c43514d30081b0104b53d23783a5fb1a2574fa2280f5054bfef80714f810081c08180a9c0b300950001014dd000a0f0703e80302035005f592100001a000000fd00384b1e873c000a202020202020000000fc00553238453835300a2020202020000000ff004854504a3230303536310a2020010a02030ef041102309070783010000023a801871382d40582c45005f592100001e565e00a0a0a02950302035005f592100001a04740030f2705a80b0588a005f592100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000052";
      office-lg.fingerprint = "00ffffffffffff001e6d07772c3a0500051f0104b53c22789e3e31ae5047ac270c50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00383d1e8738000a202020202020000000fc004c472048445220344b0a20202001fd02031c7144900403012309070783010000e305c000e606050152485d023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002c";
      home-lg.fingerprint = "00ffffffffffff001e6d0677ef340100011f0103803c2278ea3e31ae5047ac270c50542108007140818081c0a9c0d1c081000101010104740030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00383d1e873c000a202020202020000000fc004c472048445220344b0a202020013202033bc14d9022201f1f1f04015f5f5d5e5f230904076d030c002000803c2000600102036700000001788003e30f0003e3050000e6060000000000023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a000000ff003130314e54565332423038370a000000000000000000000000000055";
    };
  };

  services.autorandr = {
    enable = true;
    inherit hooks;
    profiles =
      mkProfile {
        name = "aoc-only";
        inherit (externalMonitors.home-aoc) fingerprint;
        inherit ports;
        mkConfig = mk4k;
      }
      // mkProfile {
        name = "lg-only";
        inherit (externalMonitors.home-lg) fingerprint;
        inherit ports;
        mkConfig = mk4k;
      }
      // mkProfile {
        name = "office";
        inherit (externalMonitors.office-lg) fingerprint;
        inherit ports;
        mkConfig = mk4k;
      };
  };
}
