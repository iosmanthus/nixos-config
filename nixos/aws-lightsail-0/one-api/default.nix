{ pkgs
, config
, ...
}:
let
  port = "3000";
  imageName = "ghcr.io/songquanpeng/one-api";
  imageTag = "v0.6.0";
in
{
  sops.templates."one-api.env" = {
    content = ''
      SQL_DSN=${config.sops.placeholder."one-api/sql-dsn"}
      PORT=${port}
    '';
  };

  systemd.services."docker-one-api".restartTriggers = [
    config.sops.templates."one-api.env".content
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      one-api = {
        image = "${imageName}:${imageTag}";
        imageFile = pkgs.dockerTools.pullImage {
          inherit imageName;
          finalImageTag = imageTag;
          imageDigest = "sha256:8f2151f192179a8728d3385c5cca5f4e34b629c36e6c9aa930fe7ae2c8526e57";
          sha256 = "sha256-7pikicXAghfA/V3cu/gezwQ8zwerA0VEe67BpRHD8Ps=";
        };
        autoStart = true;
        ports = [ "${port}:${port}" ];
        environmentFiles = [
          config.sops.templates."one-api.env".path
        ];
      };
    };
  };
}
