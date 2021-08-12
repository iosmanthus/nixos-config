{ pkgs
, ...
}:
{
  environment.systemPackages = with pkgs; [ docker-compose virt-manager virt-viewer ];
  virtualisation.docker = {
    enable = true;
    extraOptions = "--registry-mirror https://docker.mirrors.ustc.edu.cn --dns 172.17.0.1 --default-ulimit nofile=1048576:1048576";
  };

  users.extraGroups.docker.members = [ "iosmanthus" ];

  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''uri_default = "qemu:///system"'';
  };
  users.extraGroups.vboxusers.members = [ "iosmanthus" ];
  users.extraGroups.libvirtd.members = [ "iosmanthus" ];
}
