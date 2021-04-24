{ pkgs
, ...
}:
{
  environment.systemPackages = with pkgs; [ docker-compose ];
  virtualisation.docker = {
    enable = true;
    extraOptions = "--registry-mirror https://docker.mirrors.ustc.edu.cn --dns 172.17.0.1";
  };

  users.extraGroups.docker.members = [ "iosmanthus" ];

  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "iosmanthus" ];
}
