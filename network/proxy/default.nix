{ config
, lib
, ...
}:
with lib;

let
  eachNetwork = config.services.docker-network;
  jsonFormat = pkgs.formats.json { };
  dockerCli = "${config.virtualisation.docker.package}/bin/docker";
  dockerNetworkOpts = { name }: {
    enable = mkEnableOption "enable this docker network";
    name = mkOption { type = types.str; };
    bridgeName = mkOption { type = types.str; };
    subnet = mkOption { type = types.str; };
    opt = mkOption { type = jsonFormat.type; };
  };
in
{
  options.services.docker-network = mkOption {
    type = with types; attrsOf (submodule dockerNetworkOpts);
    default = { };
  };
  config = {
    systemd.services.docker-network-init = { };

    # {
    #   description = "Create docker network";
    #   after = [ "network.target" ];
    #   wantedBy = [ "multi-user.target" ];

    #   serviceConfig.Type = "oneshot";
    #   script = ''
    #     # Put a true at the end to prevent getting non-zero return code, which will
    #     # crash the whole service.
    #     check=$(${dockerCli} network ls | grep "${cfg.name}" || true)
    #     if [ -z "$check" ]; then
    #       ${dockerCli} network create ${cfg.name}
    #     else
    #       echo "${cfg.name} already exists in docker network list"
    #     fi
    #   '';
    # };
  };
}
