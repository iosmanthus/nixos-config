{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.services.fusuma;
in
  with lib;
  {
    options.services.fusuma = {
      enable = mkEnableOption "fusuma service";
      config = mkOption {
        type = types.attrs;
      };
      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };
    config =
      let
        configJSON = pkgs.writeText "config.json" (builtins.toJSON cfg.config);
        configYAMLRaw = pkgs.runCommand "config.yaml.raw" {} ''
          ${pkgs.remarshal}/bin/json2yaml -i ${configJSON} -o $out;
        '';


        configYAML =
          let
            strToInt = pkgs.writeText "str2int" ''
              import yaml
              from yaml import FullLoader

              def str2int(config, parent):
                  if parent in config:
                      for k in dict(config[parent]):
                          v = config[parent][k]
                          del config[parent][k]
                          config[parent][int(k)] = v

              with open("${configYAMLRaw}") as f:
                  config = yaml.load(f, Loader=FullLoader)
                  str2int(config, 'swipe')
                  str2int(config, 'pinch')
                  print(yaml.dump(config))
            '';
          in
            pkgs.stdenv.mkDerivation {
              name = "config.yaml";
              buildInputs = with pkgs.python39Packages;[
                python
                pyyaml
              ];
              buildCommand = ''
                python ${strToInt} > $out
              '';
            };
        pathOf = packages:
          foldl
            (a: b: if a == "" then b else "${a}:${b}")
            ""
            (map (pkg: "${pkg}/bin") packages)
        ;
      in
        mkIf cfg.enable
          {
            systemd.user.services.fusuma = {
              Unit = {
                Description = "Fusuma services";
                After = [ "graphical-session-pre.target" ];
                PartOf = [ "graphical-session.target" ];
              };
              Service = {
                Environment = with pkgs; "PATH=${pathOf ([ coreutils ] ++ cfg.extraPackages)}";
                ExecStart = "${pkgs.fusuma}/bin/fusuma -c ${configYAML}";
              };
              Install = {
                WantedBy = [ "graphical-session.target" ];
              };
            };
          };
  }
