{ config
, pkgs
, lib
, ...
}:
let cfg = config.services.fusuma;
in
with lib; {
  meta.maintainers = with maintainers; [ iosmanthus ];
  options.services.fusuma = {
    enable = mkEnableOption
      "the fusuma systemd service to automatically enable touchpad gesture";
    package = mkOption {
      type = types.package;
      default = pkgs.fusuma;
      defaultText = literalExpression "pkgs.fusuma";
      description = "Package providing <command>fusuma</command>.";
    };
    settings = mkOption {
      type = types.attrs;
      example = literalExpression ''
        {
          enable = true;
          extraPackages = with pkgs;[ xdotool ];
          config = {
            threshold = {
              swipe = 0.1;
            };
            interval = {
              swipe = 0.7;
            };
            swipe = {
              "3" = {
                left = {
                  # GNOME: Switch to left workspace
                  command = "xdotool key ctrl+alt+Right";
                };
              };
            };
          };
        };
      '';
      description = ''
        YAML config that will override the default Astroid configuration. 
      '';
    };
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [ coreutils ];
      defaultText = literalExpression "pkgs.coreutils";
      example = literalExpression ''
        with pkgs; [ coreutils xdotool ];
      '';
      description = ''
        Extra packages needs to bring to the scope of fusuma service.
      '';
    };
  };
  config =
    let
      configJSON = pkgs.writeText "config.json" (builtins.toJSON cfg.settings);
      configYAMLRaw = pkgs.runCommand "config.yaml.raw" { } ''
        ${pkgs.remarshal}/bin/json2yaml -i ${configJSON} -o $out;
      '';

      configYAML =
        let
          strToInt = pkgs.writeText "str2int" ''
            import yaml
            from yaml import FullLoader

            def str2int(config):
                if type(config) is not dict:
                    return

                for key in list(config):
                    if type(config[key]) is dict and key.isdigit():
                        t = config[key]
                        del config[key]
                        config[int(key)] = t
                    else:
                        str2int(config[key])

            with open("${configYAMLRaw}") as f:
                config = yaml.load(f, Loader=FullLoader)
                str2int(config)
                print(yaml.dump(config))
          '';
        in
        pkgs.stdenv.mkDerivation {
          name = "config.yaml";
          buildInputs = with pkgs.python39Packages; [ python pyyaml ];
          buildCommand = ''
            python ${strToInt} > $out
          '';
        };
      pathOf = packages:
        foldl (a: b: if a == "" then b else "${a}:${b}") ""
          (map (pkg: "${pkg}/bin") packages);
    in
    mkIf cfg.enable {
      xdg.configFile."fusuma/config.yaml".source = configYAML;
      systemd.user.services.fusuma = {
        Unit = {
          Description = "Fusuma services";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Environment = with pkgs; "PATH=${pathOf cfg.extraPackages}";
          ExecStart =
            "${cfg.package}/bin/fusuma -c ${config.xdg.configHome}/fusuma/config.yaml";
        };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
    };
}
