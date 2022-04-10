{ config
, pkgs
, lib
, ...
}:
with lib;
let
  cfg = config.virtualisation.clash-container;
in
{
  options.virtualisation.clash-container = {
    enable = mkEnableOption "Enable clash services";

    image = mkOption {
      type = types.str;
    };

    imageFile = mkOption {
      type = with types; nullOr package;
    };

    configFile = mkOption {
      type = types.path;
    };

    mmdb = mkOption {
      type = types.package;
    };

    dependsOn = mkOption {
      default = [ ];
      type = with types; listOf str;
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        clash = rec {
          image = cfg.image;
          imageFile = cfg.imageFile;
          workdir = "/etc/clash";
          cmd = [ "-d" "./" ];
          volumes = [
            "${cfg.configFile}:${workdir}/config.yaml"
            "${cfg.mmdb}:${workdir}/Country.mmdb"
          ];
          extraOptions = cfg.extraOptions;
          dependsOn = cfg.dependsOn;
        };
      };
    };
  };
}
