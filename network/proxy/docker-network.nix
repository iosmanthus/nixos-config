{ config
, lib
, ...
}:
with lib;

let
  eachNetwork = config.services.docker-network;

  dockerCli = "${config.virtualisation.docker.package}/bin/docker";

  dockerNetworkOpts = { config, lib, name, ... }: {
    options = {
      enable = mkEnableOption "enable this docker network";
      subnet = mkOption {
        type = types.str;
      };
      opts = mkOption {
        type = with types; attrsOf str;
      };
    };
  };

  mkOptList = mapAttrsToList (name: value: "--opt ${name}=${value}");

  mkOptStr = opts: foldl (acc: x: "${acc} ${x}") "" (mkOptList opts);

in
{
  options.services.docker-network = mkOption {
    type = with types; attrsOf (submodule dockerNetworkOpts);
    default = { };
  };

  config = mkIf (eachNetwork != { }) {
    systemd.services = mapAttrs'
      (netName: netCfg: (
        nameValuePair "docker-network-${netName}-init" (mkIf netCfg.enable {
          description = "initialise the docker network ${netName}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''
            check=$(${dockerCli} network inspect "${netName}" || true)
            if [ "$check" = "[]" ]; then
              ${dockerCli} network create --subnet ${netCfg.subnet} ${netName} ${mkOptStr netCfg.opts}
            else
              echo "${netName} already exists in docker network list"
            fi
          '';
        })
      ))
      eachNetwork;
  };
}
