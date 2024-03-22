{ config
, pkgs
, ...
}:
let
  imageName = "gosuto/chatgpt-next-web-langchain";
  imageTag = "v2.11.2";
  imageDigest = "sha256:b1435d1e97741c0ffdd260e84595b0afebcc6889f3ec1f1f7b04d81e216848ef";
  imageSha256 = "sha256-3p/+rdFNbSzyFmP1ogK/GFGkSIK8EzY651ez/yy2rds=";
in
{
  sops.templates."chatgpt-next-web.env" = {
    content = ''
      BASE_URL=https://openai.iosmanthus.com
      CHOOSE_SEARCH_ENGINE=google
      DALLE_NO_IMAGE_STORAGE=1
      CODE=${config.sops.placeholder."chatgpt-next-web/password"}
      GOOGLE_API_KEY=${config.sops.placeholder."chatgpt-next-web/google-api-key"}
      GOOGLE_CSE_ID=${config.sops.placeholder."chatgpt-next-web/google-cse-id"}
      OPENAI_API_KEY=${config.sops.placeholder."chatgpt-next-web/openai-api-key"}
    '';
  };

  systemd.services."docker-chatgpt-next-web".restartTriggers = [
    config.sops.templates."chatgpt-next-web.env".content
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      "chatgpt-next-web" = {
        image = "${imageName}:${imageTag}";
        imageFile = pkgs.dockerTools.pullImage {
          inherit imageName imageDigest;
          finalImageTag = imageTag;
          sha256 = imageSha256;
        };
        ports = [ "3210:3000" ];
        environmentFiles = [
          config.sops.templates."chatgpt-next-web.env".path
        ];
      };
    };
  };
}

