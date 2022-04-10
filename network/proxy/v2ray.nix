{ config
, pkgs
, lib
, ...
}:
with lib;
let
  cfg = config.virtualisation.v2ray-container;
in
{
  options.virtualisation.v2ray-container = {
    enable = mkEnableOption "Enable v2ray services";

    image = mkOption {
      type = types.str;
    };

    imageFile = mkOption {
      type = with types; nullOr package;
    };

    configFile = mkOption {
      type = types.path;
    };

    geosite = mkOption {
      type = types.package;
    };

    geoip = mkOption {
      type = types.package;
    };

    dependsOn = mkOption {
      default = [ ];
      type = with types; listOf str;
    };

    extraOptions = mkOption {
      type = with types;
        listOf str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        v2ray = rec {
          image = cfg.image;
          imageFile = cfg.imageFile;
          workdir = "/etc/v2ray";
          cmd = [ "xray" "run" "-confdir" "./" ];
          volumes = [
            "${cfg.configFile}:${workdir}/config.json"
            "${cfg.geoip}:${workdir}/geoip.dat"
            "${cfg.geosite}:${workdir}/geosite.dat"
          ];
          extraOptions = cfg.extraOptions;
          dependsOn = cfg.dependsOn;
        };
      };
    };
  };
}
