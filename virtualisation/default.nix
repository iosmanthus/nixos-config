{ pkgs
, ...
}:
{
  environment.systemPackages = with pkgs; [ docker-compose virt-manager virt-viewer ];
  virtualisation.docker = {
    enable = true;
    extraOptions = "--mtu 1420 --network-control-plane-mtu 1420 --default-ulimit nofile=1048576:1048576";
  };

  users.extraGroups.docker.members = [ "iosmanthus" ];

  virtualisation.libvirtd = {
    enable = true;
  };
  users.extraGroups.vboxusers.members = [ "iosmanthus" ];
  users.extraGroups.libvirtd.members = [ "iosmanthus" ];
}
